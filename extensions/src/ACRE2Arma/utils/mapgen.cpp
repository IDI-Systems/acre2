#include "shared.hpp"
#include "pbo/archive.hpp"
#include "membuf.hpp"
#include "logging.hpp"
#include "map/map.hpp"
#include <iostream>
#include <fstream>
#include <thread>
#include <mutex>
#include <regex>
#include "antenna/antenna_library.hpp"
#include "antenna/antenna.hpp"

#include "models/los_simple.hpp"

#include "glm/geometric.hpp"

#include "glm/gtx/vector_angle.hpp"

#include "wrp/landscape.hpp"

#include "bitmap_image.hpp"

#include "glm/gtx/gradient_paint.hpp"
#include "lodepng.h"

INITIALIZE_EASYLOGGINGPP

#define READ_STRING(output) { \
                                    std::stringstream ss; \
                                      for (int32_t x = 0; x < 2056;x++) { char byte = 0; stream_.read((char *)&byte, 1);  if (byte == 0x00) break; ss << byte;  } \
                                    output = ss.str(); \
                                    }



struct signal_map_result {
    glm::vec3 rx_pos;
    glm::vec3 tx_pos;
    acre::signal::result result;
};
typedef std::shared_ptr<signal_map_result> signal_map_result_p;

acre::signal::map_p map;

acre::signal::model::multipath *signal_processor;

std::mutex signal_lock;

uint32_t signal_map_progress;

void draw_square(std::vector<uint8_t> &image_, uint32_t image_size_x_, uint32_t image_size_y_, uint32_t square_size_, uint32_t x_, uint32_t y_, uint8_t r_, uint8_t g_, uint8_t b_, uint8_t a_) {
    for (uint32_t y = y_*square_size_; y < y_*square_size_ + square_size_; ++y) {
        for (uint32_t x = x_*square_size_; x < x_*square_size_ + square_size_; ++x) {
            image_[4 * image_size_x_ * ((image_size_y_ - 1) - y) + 4 * x + 0] = r_;
            image_[4 * image_size_x_ * ((image_size_y_ - 1) - y) + 4 * x + 1] = g_;
            image_[4 * image_size_x_ * ((image_size_y_ - 1) - y) + 4 * x + 2] = b_;
            image_[4 * image_size_x_ * ((image_size_y_ - 1) - y) + 4 * x + 3] = a_;
        }
    }
}

void signal_map_chunk(std::vector<signal_map_result_p> *results, const float32_t start_y, const float32_t start_x, const uint32_t y_offset, const uint32_t length, const uint32_t x_size, const float32_t sample_size,
                      const float32_t rx_antenna_height, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const acre::signal::antenna_p &tx_antenna_, const acre::signal::antenna_p &rx_antenna_, const float32_t frequency_, const float32_t power_,
                      const float32_t sinad_, const bool omnidirectional_) {
    for (uint32_t y = y_offset; y < y_offset + length; ++y) {
        for (uint32_t x = 0u; x < x_size; ++x) {
            const float32_t rx_x_pos = start_x + (static_cast<float32_t>(x)*sample_size) + (sample_size / 2.0f);
            const float32_t rx_y_pos = start_y + (static_cast<float32_t>(y)*sample_size) + (sample_size / 2.0f);
            const float32_t z = map->elevation(rx_x_pos, rx_y_pos) + rx_antenna_height;
            signal_map_result_p result = std::make_shared<signal_map_result>();
            result->rx_pos = glm::vec3(rx_x_pos, rx_y_pos, z);
            result->tx_pos = glm::vec3(tx_pos_);
            signal_processor->process(&result->result, tx_pos_, tx_dir_, result->rx_pos, glm::vec3(0.0f, 1.0f, 0.0f), tx_antenna_, rx_antenna_, frequency_, power_, 12.0f, omnidirectional_);
            {
                std::lock_guard<std::mutex> lock(signal_lock);
                results->at(y * x_size + x) = result;
                signal_map_progress++;
            }
        }
    }
}

void write_progress(uint32_t total_size) {
    int32_t x = 0; int32_t y = 0;
    COORD pos = { x, y };
    HANDLE hConsole_c = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, 0, NULL, CONSOLE_TEXTMODE_BUFFER, NULL);
    bool run = true;
    while (run) {
        {
            std::lock_guard<std::mutex> lock(signal_lock);
            std::stringstream ss;
            ss.precision(4);

            const float32_t percent = ((static_cast<float32_t>(signal_map_progress) / static_cast<float32_t>(total_size))*100.0f);
            ss << "Complete: " << percent << "%";
            std::string p = ss.str();
            const char *str = p.c_str();
            DWORD len = strlen(str);
            DWORD dwBytesWritten = 0;
            SetConsoleActiveScreenBuffer(hConsole_c);
            WriteConsoleOutputCharacter(hConsole_c, "                            ", 29, pos, &dwBytesWritten);
            WriteConsoleOutputCharacter(hConsole_c, str, len, pos, &dwBytesWritten);
            
            if (signal_map_progress >= total_size) {
                run = false;
            }
        }
        Sleep(50);
    }
    CloseHandle(hConsole_c);
}

float32_t get_percentage(const float32_t s_, const float32_t min_, const float32_t max_) {
    return (std::min)((std::max)(((s_ - min_) / (max_ - min_)), 0.0f), 1.0f);
}

void draw_bitmap(const int32_t offset_x_, const int32_t offset_y_, const int32_t size_x_, const int32_t size_y_, const acre::signal::map_p &map_, const std::string &output_path_) {
    int32_t offset_x = offset_x_;
    int32_t offset_y = offset_y_;
    int32_t size_x = size_x_;
    int32_t size_y = size_y_;
    int32_t scale = 1;

    offset_x = offset_x * scale;
    offset_y = offset_y * scale;
    if (size_x > 0) {
        size_x = size_x * scale;
    } else {
        size_x = map_->map_size() * scale;
    }

    if (size_y > 0) {
        size_y = size_y * scale;
    } else {
        size_y = map_->map_size() * scale;
    }

    const int32_t map_size = map_->map_size()*scale;
    const float32_t cell_sample_size = map_->cell_size() / scale;
    //bitmap_image image(size_x, size_y);

    bool useBitGradients = false;
    bitmap_image land_grad;
    bitmap_image sea_grad;

    //land_grad = bitmap_image("d:\\land_grad.bmp");
    //sea_grad = bitmap_image("d:\\sea_grad.bmp");

    std::vector<uint8_t> png_data;
    png_data.resize((size_x + 1) * (size_y + 1) * 4);
    std::fill(png_data.begin(), png_data.end(), 0);

    float32_t min_height = 10000.0f;
    float32_t max_height = -10000.0f;
    for (uint32_t x = 0u; x < map_->map_size(); ++x) {
        for (uint32_t y = 0u; y < map_->map_size(); ++y) {
            const float32_t height = map_->elevation_raw(x, y);
            max_height = std::max(max_height, height);
            min_height = std::min(min_height, height);
        }
    }

    glm::vec3 light_source = glm::vec3(-1.0f, -1.0f, 0.5f);
    light_source = glm::normalize(light_source);
    int32_t image_x = 0;
    int32_t image_y = 0;
    for (int32_t y = offset_y; y < std::min(offset_y + size_y, map_size - scale); ++y, ++image_y) {
        image_x = 0;
        for (int32_t x = offset_x; x < std::min(offset_x + size_x, map_size - scale); ++x, ++image_x) {

            float32_t r_x = 0.0f, r_y = 0.0f;
            const float32_t height = map_->elevation(static_cast<float32_t>(x) * cell_sample_size, static_cast<float32_t>(y) * cell_sample_size, &r_x, &r_y);

            //glm::vec3 normal = test_map->normal((float)x * cell_sample_size, (float)y * cell_sample_size);

            const glm::vec3 normal = glm::normalize(glm::vec3(-r_x, -r_y, 1.0f));
            const float32_t factor = glm::dot(normal, -light_source);

            float32_t colorR = 0.0f;
            float32_t colorG = 0.0f;
            float32_t colorB = 0.0f;

            if (height > 0.0f) {
                //r.R = fg.R * fg.A / r.A + bg.R * bg.A * (1 - fg.A) / r.A; // 0.67
                //r.G = fg.G * fg.A / r.A + bg.G * bg.A * (1 - fg.A) / r.A; // 0.33
                //r.B = fg.B * fg.A / r.A + bg.B * bg.A * (1 - fg.A) / r.A; // 0.00
                const float32_t shade = 254.0f * std::min(factor, 0.0f);
                const float32_t shadow = 254.0f + shade;
                float32_t color_index = height / max_height;

                //land_grad.get_pixel(static_cast<uint32_t>(color_index * 254.0f), 0u, colorR, colorG, colorB);
                colorR = (1.0f - color_index) * 248.0f + color_index * 104.0f;
                colorG = (1.0f - color_index) * 218.0f + color_index * 75.0f;
                colorB = (1.0f - color_index) * 150.0f + color_index * 13.0f;

                const float32_t fa = 0.5f;
                const float32_t ba = 1.0f - fa;
                float32_t r = colorR / 255.0f;
                float32_t g = colorG / 255.0f;
                float32_t b = colorB / 255.0f;
                const float32_t s = shadow / 255.0f;

                const float32_t ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75

                r = s * fa / ra + r * ba * (1.0f - fa) / ra;
                g = s * fa / ra + g * ba * (1.0f - fa) / ra;
                b = s * fa / ra + b * ba * (1.0f - fa) / ra;


                colorR = static_cast<uint8_t>(r * 254.0f);
                colorG = static_cast<uint8_t>(g * 254.0f);
                colorB = static_cast<uint8_t>(b * 254.0f);

                //colorR = colorG = colorB = color_index + shadow;
            } else {
                const float32_t shade = 127.0f * factor;
                const float32_t shadow = 127.0f + shade;
                float32_t color_index = 1.0f - (std::abs(height) / std::abs(min_height));

                //sea_grad.get_pixel(static_cast<uint32_t>(color_index * 254.0f), 0, colorR, colorG, colorB);
                colorR = (1.0f - color_index) * 25.0f + color_index * 172.0f;
                colorG = (1.0f - color_index) * 79.0f + color_index * 224.0f;
                colorB = (1.0f - color_index) * 107.0f + color_index * 251.0f;
                
                const float32_t fa = 0.35f;
                const float32_t ba = 1.0f - fa;
                float32_t r = colorR / 255.0f;
                float32_t g = colorG / 255.0f;
                float32_t b = colorB / 255.0f;
                const float32_t s = shadow / 255.0f;

                const float32_t ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75

                r = s * fa / ra + r * ba * (1.0f - fa) / ra;
                g = s * fa / ra + g * ba * (1.0f - fa) / ra;
                b = s * fa / ra + b * ba * (1.0f - fa) / ra;


                colorR = static_cast<uint8_t>(r * 254.0f);
                colorG = static_cast<uint8_t>(g * 254.0f);
                colorB = static_cast<uint8_t>(b * 254.0f);
                //colorR = colorG = colorB = 254;
            }
            //image.set_pixel(x - offset_x, (size_y - 1) - (y - offset_y), colorR, colorG, colorB);
            png_data[4 * size_x * (size_y - image_y) + 4 * image_x + 0] = static_cast<uint8_t>(colorR);
            png_data[4 * size_x * (size_y - image_y) + 4 * image_x + 1] = static_cast<uint8_t>(colorG);
            png_data[4 * size_x * (size_y - image_y) + 4 * image_x + 2] = static_cast<uint8_t>(colorB);
            png_data[4 * size_x * (size_y - image_y) + 4 * image_x + 3] = 128;
            //draw_square(png_data, size_x, size_y, 1, x, y, colorR, colorG, colorB, 128);
        }
    }
    
    lodepng::State state;
    state.encoder.auto_convert = false;
    std::vector<unsigned char> png;
    unsigned error = lodepng::encode(png, png_data, size_x, size_y, state);

    //GetModuleFileName(NULL, path, len);
    if (!error) lodepng::save_file(png, output_path_.c_str());
}

std::string process_template(std::unordered_map < std::string, std::string > &config_) {
    std::ifstream template_file(config_["html_template"]);
    std::string output = "";
    std::string line;
     while (std::getline(template_file, line)) {
        for (auto config_entry : config_) {
            std::string key = config_entry.first;
            std::smatch matches;
            std::string val = config_entry.second;
            std::regex exp("%%" + key + "%%");
            line = std::regex_replace(line, exp, val);
        }
        output += line + "\n";
    }
    return output;
}




int main(int argc, char **argv) {
    if (argc != 3) {
        return 0;
    }

    std::unordered_map < std::string, std::string > config;
    std::ifstream config_file(argv[1]);
    if (config_file.is_open()) {
        std::string line;
        std::smatch matches;
        std::regex exp("(\\w+?)\\s+?=\\s*([^\\s].*)");
        while (std::getline(config_file, line)) {
            if (std::regex_match(line.cbegin(), line.cend(), matches, exp)) {
                std::cout << matches[1] << ": " << matches[2] << "\n";
                config[matches[1].str()] = matches[2].str();
            }
        }
    } else {
        return 0;
    }
    
    std::string file_path(argv[2]);

    config["signal_overlay_path"] = file_path + "_signal.png";
    config["ground_overlay_path"] = file_path + "_ground.png";

    std::ifstream _filestream(config["bin_map_file"]);
    bool loaded = false;
    acre::wrp::LandscapeResult ok = acre::signal::map_loader::get().get_map(config["asc_header_file"], map, loaded);
    //map = std::make_shared<acre::signal::map>(config["bin_map_file"]);
    //map->load_asc_header(config["asc_header_file"]);
    signal_processor = new acre::signal::model::multipath(map);

    const float64_t tx_pos_lat = std::stod(config["tx_pos_lat"]);
    const float64_t tx_pos_long = std::stod(config["tx_pos_long"]);

    const float64_t rx_area_ll_lat = std::stod(config["rx_area_ll_lat"]);
    const float64_t rx_area_ll_long = std::stod(config["rx_area_ll_long"]);

    const float64_t rx_area_ur_lat = std::stod(config["rx_area_ur_lat"]);
    const float64_t rx_area_ur_long = std::stod(config["rx_area_ur_long"]);

    const float64_t asc_cell_size = map->cell_size(); //map->asc_header["cellsize"];

    const float64_t rx_area_width = rx_area_ur_long - rx_area_ll_long;
    const float64_t rx_area_height = rx_area_ur_lat - rx_area_ll_lat;

    const float32_t cell_size_meters = map->cell_size();//10.0f;

    const float64_t asc_area_origin_lat = 0.0f;// map->asc_header["yllcorner"];
    const float64_t asc_area_origin_long = 0.0f; //map->asc_header["xllcorner"];
    const int32_t offset_x = 0.0f; // static_cast<int32_t>((rx_area_ll_long - asc_area_origin_long) / asc_cell_size);
    const int32_t offset_y = 0.0f; // static_cast<int32_t>((rx_area_ll_lat - asc_area_origin_lat) / asc_cell_size);
    //draw_bitmap(offset_x, offset_y, static_cast<int32_t>(rx_area_width / asc_cell_size), static_cast<int32_t>(rx_area_height / asc_cell_size), map, file_path + "_ground.png");
    draw_bitmap(offset_x, offset_y, -1, -1, map, file_path + "_ground.png");

    std::cout << "RX Start Offset X: " << ((rx_area_ll_long - asc_area_origin_long)/asc_cell_size) << "\n";
    std::cout << "RX Start Offset Y: " << (rx_area_ll_lat - asc_area_origin_lat)/asc_cell_size << "\n";

    std::ifstream tx_antenna_file;
    tx_antenna_file.open(config["tx_antenna_file"]);
    acre::signal::antenna_p tx_antenna = std::make_shared<acre::signal::antenna>(tx_antenna_file);

    std::ifstream rx_antenna_file;
    rx_antenna_file.open(config["rx_antenna_file"]);
    acre::signal::antenna_p rx_antenna = std::make_shared<acre::signal::antenna>(rx_antenna_file);

    glm::vec3 tx_pos = glm::vec3(((tx_pos_long - asc_area_origin_long) / asc_cell_size) * cell_size_meters, ((tx_pos_lat - asc_area_origin_lat) / asc_cell_size) * cell_size_meters, 0.0f);
    
    tx_pos.z = map->elevation(tx_pos.x, tx_pos.y) + stof(config["tx_height"]);
    const glm::vec3 tx_dir = glm::vec3(0.0f, 1.0f, 0.0f);

    const float32_t rx_antenna_height = stof(config["tx_height"]);

    const float32_t sample_size = stof(config["sample_size"]);
    const glm::vec3 start_pos = glm::vec3(0.0f, 0.0f, 0.0f);// glm::vec3(((rx_area_ll_long - asc_area_origin_long) / asc_cell_size) * cell_size_meters, ((rx_area_ll_lat - asc_area_origin_lat) / asc_cell_size) * cell_size_meters, 0.0f);
    const glm::vec3 end_pos = glm::vec3(map->map_size(), map->map_size(), 0.0f);// glm::vec3(((rx_area_ur_long - asc_area_origin_long) / asc_cell_size) * cell_size_meters, ((rx_area_ur_lat - asc_area_origin_lat) / asc_cell_size) * cell_size_meters, 0.0f);

    const float32_t f = stof(config["tx_frequency"]);
    const float32_t power = stof(config["tx_power"]);

    const float32_t lower_sensitivity = -116.0f;
    const float32_t upper_sensitivity = -50.0f;

    const bool omnidirectional = stof(config["omnidirectional"]);

    const float32_t start_x = start_pos.x;
    const float32_t start_y = start_pos.y;

    float32_t width = (end_pos.x - start_pos.x);
    float32_t height = (end_pos.y - start_pos.y);

    if (start_x + width > map->cell_size()*map->map_size()) {
        width = width - ((map->cell_size()*map->map_size()) - (start_x + width));
    }

    if (start_y + height > map->cell_size()*map->map_size()) {
        height = height - ((map->cell_size()*map->map_size()) - (start_y + height));
    }

    const uint32_t count_x = static_cast<uint32_t>(std::floor(width / sample_size));
    const uint32_t count_y = static_cast<uint32_t>(std::floor(height / sample_size));
    const uint32_t image_size_x = static_cast<uint32_t>(std::floor(width / sample_size) * sample_size);
    const uint32_t image_size_y = static_cast<uint32_t>(std::floor(width / sample_size) * sample_size);

    uint32_t thread_count = 6u;

    uint32_t y_chunk_size, y_chunk_remainder;
    if (count_y > thread_count) {
        y_chunk_size = static_cast<uint32_t>(std::floor(count_y / thread_count));
        y_chunk_remainder = count_y % thread_count;
    } else {
        y_chunk_size = 1u;
        thread_count = count_y;
        y_chunk_remainder = 0u;
    }
    std::vector<std::thread> thread_pool;
    std::vector<signal_map_result_p> results;
    results.resize(count_x * count_y);

    for (uint32_t i = 0u; i < thread_count; ++i) {
        thread_pool.push_back(std::thread(&signal_map_chunk, &results, start_y, start_x, y_chunk_size*i, y_chunk_size, count_x, sample_size,
            rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f, omnidirectional));
    }
    if (y_chunk_remainder) {
        thread_pool.push_back(std::thread(&signal_map_chunk, &results, start_y, start_x, y_chunk_size*thread_count, y_chunk_remainder, count_x, sample_size,
            rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f, omnidirectional));
    }
    std::thread progress_thread = std::thread(&write_progress, count_x * count_y);
    for (size_t c = 0u; c < thread_pool.size(); ++c) {
        thread_pool[c].join();
    }
    progress_thread.join();
    
    std::vector<uint8_t> png_data;
    png_data.resize(image_size_x * image_size_y * 4u);
    std::fill(png_data.begin(), png_data.end(), 0);
    std::string sampleDataJson = "";
    for (uint32_t y = 0u; y < count_y; ++y) {
        for (uint32_t x = 0u; x < count_x; ++x) {
            const auto result = results.at(y * count_x + x)->result;
            const float32_t s = result.result_dbm;
            const float32_t p = get_percentage(s, lower_sensitivity, upper_sensitivity);
            std::stringstream ss;
            ss.precision(8);
            if (result.reflect_points.size() > 0) {
                ss << "{\n";
                ss << "strength:" << result.result_dbm << ",\n";
                ss << "reflections: [\n";
                for (auto reflection : result.reflect_points) {
                    ss.precision(8);
                    ss << "\t{\n";
                    ss << "\t\tbudget:" << reflection.path_budget_dbm << ",\n";
                    ss << "\t\tphase:" << reflection.phase << ",\n";

                    ss << "\t\tcoef:" << reflection.reflect_coefficient << ",\n";
                    const float64_t point_lat = asc_area_origin_lat + ((reflection.point.y / cell_size_meters) * asc_cell_size);
                    const float64_t point_long = asc_area_origin_long + ((reflection.point.x / cell_size_meters) * asc_cell_size);
                    ss.precision(16);
                    ss << "\t\tlat:" << point_lat << ",\n";
                    ss << "\t\tlng:" << point_long << "\n";
                    ss << "\t},\n";
                }
                ss << "\t,{}\n";
                ss << "]\n},\n";
            }
            else {
                ss << "{},\n";
            }
            
            sampleDataJson += ss.str();
            draw_square(png_data, image_size_x, image_size_y, static_cast<uint32_t>(sample_size), x, y, static_cast<uint8_t>(255.0f * (1.0f - p)), static_cast<uint8_t>(255.0f * p), 0, static_cast<uint8_t>(225.0f * p));
        }
    }
    sampleDataJson = "[" + sampleDataJson + ",{}]";
    config["sample_data"] = sampleDataJson;
    std::stringstream offset_size_ss;
    offset_size_ss.precision(24);
    offset_size_ss << asc_cell_size * (sample_size / cell_size_meters);
    config["offset_size"] = offset_size_ss.str();
    const std::string template_contents = process_template(config);
    std::ofstream out(file_path + ".html");
    out << template_contents;
    out.close();

    lodepng::State state;
    state.encoder.auto_convert = false;
    std::vector<unsigned char> png;
    const uint32_t error = lodepng::encode(png, png_data, image_size_x, image_size_y, state);

    std::string output_path = file_path + "_signal.png";
    if (!error) lodepng::save_file(png, output_path.c_str());

    std::cout << "DONE!";
    getchar();
    return 0;
}
