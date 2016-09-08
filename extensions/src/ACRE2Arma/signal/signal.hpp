#pragma once
#define NOMINMAX 1
#include <algorithm>
#include "shared.hpp"
#include "controller.hpp"
#include <sstream>
#include "map\map.hpp"
#include "models\los_simple.hpp"
#include "antenna\antenna_library.hpp"
#include "lodepng.h"
#ifdef _WINDOWS
#include <direct.h>
#endif

namespace acre {
    namespace signal {
        struct signal_map_result {
            signal_map_result() { }
            signal_map_result(const signal_map_result &copy_) {
                rx_pos = copy_.rx_pos;
                tx_pos = copy_.tx_pos;
                result = copy_.result;
            }
            signal_map_result(signal_map_result &&move_) {
                rx_pos = std::move(move_.rx_pos);
                tx_pos = std::move(move_.tx_pos);
                result = std::move(move_.result);
            }
            signal_map_result & operator=(const signal_map_result &copy_) {
                rx_pos = copy_.rx_pos;
                tx_pos = copy_.tx_pos;
                result = copy_.result;
                return *this;
            }
            signal_map_result & operator=(signal_map_result &&move_) {
                if (this == &move_) {
                    return *this;
                }
                rx_pos = std::move(move_.rx_pos);
                tx_pos = std::move(move_.tx_pos);
                result = std::move(move_.result);
                return *this;
            }

            glm::vec3 rx_pos;
            glm::vec3 tx_pos;
            acre::signal::result result;
        };
        //typedef std::shared_ptr<signal_map_result> signal_map_result_p;

        class controller : public controller_module {
        protected:
            uint32_t _debug_id;
            acre::signal::map_p _map;
            acre::signal::model::multipath _signal_processor;
            uint32_t _total_signal_map_steps;
            volatile uint32_t _signal_map_progress;
            std::mutex _signal_lock;

            std::map<std::string, std::vector<signal_map_result>> _signal_map_areas;

            float _get_percentage(float s_, float min_, float max_) {
                return (std::min)((std::max)(((s_ - min_) / (max_ - min_)), 0.0f), 1.0f);
            }
        public:
            controller() {
                acre::controller::get().add("load_map", std::bind(&controller::load, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("process_signal", std::bind(&controller::process, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("peaks", std::bind(&controller::peaks, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("load_antenna", std::bind(&controller::load_antenna, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("signal_map", std::bind(&controller::signal_map, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("signal_map_progress", std::bind(&controller::signal_map_progress, this, std::placeholders::_1, std::placeholders::_2));
                acre::controller::get().add("signal_map_get_sample_data", std::bind(&controller::signal_map_get_sample_data, this, std::placeholders::_1, std::placeholders::_2));

                _debug_id = 0;
            };
            ~controller() { };

            bool load(const arguments & args_, std::string & result) {
                bool loaded = false;
                bool ok = acre::signal::map_loader::get().get_map(args_.as_string(0), _map, loaded);
                if (ok) {
                    if (!loaded) {
                        _signal_processor = acre::signal::model::multipath(_map);
                    }
                    LOG(INFO) << "Map Loaded";
                    result = "1";
                }
                else {
                    result = "-1";
                }
                return true;
            }
            //#define DEBUG_OUTPUT
            bool process(const arguments & args_, std::string & result) {
                if (args_.size() != 21) {
                    result = "[]";
                    return true;
                }
                
                int logging = args_.as_int(19);
                bool omnidirectional = args_.as_int(20) == 1;

                std::string id = args_.as_string(0);
                glm::vec3 tx_pos = glm::vec3(args_.as_float(1), args_.as_float(2), args_.as_float(3));
                glm::vec3 tx_dir = glm::vec3(args_.as_float(4), args_.as_float(5), args_.as_float(6));
                std::string tx_antenna_name = args_.as_string(7);
                glm::vec3 rx_pos = glm::vec3(args_.as_float(8), args_.as_float(9), args_.as_float(10));
                glm::vec3 rx_dir = glm::vec3(args_.as_float(11), args_.as_float(12), args_.as_float(13));
                std::string rx_antenna_name = args_.as_string(14);

                acre::signal::antenna_p tx_antenna;
                acre::signal::antenna_p rx_antenna;

                if (!acre::signal::antenna_library::get().get_antenna(tx_antenna_name, tx_antenna)) {
                    result = "[]";
                    LOG(INFO) << "MISSING ANTENNA FROM LIBRARY: " << tx_antenna_name;
                    return true;
                }

                if (!acre::signal::antenna_library::get().get_antenna(rx_antenna_name, rx_antenna)) {
                    result = "[]";
                    LOG(INFO) << "MISSING ANTENNA FROM LIBRARY: " << rx_antenna_name;
                    return true;
                }

                float f = args_.as_float(15);
                float power = args_.as_float(16);
                float scale = args_.as_float(17);
                
                acre::signal::result signal_result;

                _signal_processor.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, f, power, scale, omnidirectional);
#ifdef DEBUG_OUTPUT
                std::stringstream filename;
                filename << "ref_" << _debug_id << ".sqf";
                ++_debug_id;
                std::ofstream demo_file("userconfig\\debug_signal\\" + filename.str());
                std::stringstream ss;
                ss.precision(16);
                ss << "[\"" << id << "\"," << std::fixed << signal_result.result_dbm << "," << std::fixed << signal_result.result_v << ",\"" << filename.str() << "\"]";
                result = ss.str();
#else    
                std::stringstream ss;
                ss.precision(16);
                ss << "[\"" << id << "\"," << std::fixed << signal_result.result_dbm << "," << std::fixed << signal_result.result_v << "]";
                result = ss.str();

                if (logging >= 1) {
                    LOG(INFO) << "SIGNAL: " << args_.get() << signal_result.result_dbm << "," << signal_result.result_v;
                }

#endif
#ifdef DEBUG_OUTPUT            
                ss << ",[" << tx_pos.x << "," << tx_pos.y << "," << tx_pos.z << "],[" << rx_pos.x << "," << rx_pos.y << "," << rx_pos.z << "],[";
                for (acre::signal::reflection reflection : signal_result.reflect_points) {
                    ss << "[" << "[" << reflection.point.x << "," << reflection.point.y << "," << reflection.point.z << "],"
                        << "[" << reflection.normal.x << "," << reflection.normal.y << "," << reflection.normal.z << "],"
                        << reflection.phase << ","
                        << reflection.reflect_coefficient << "," << reflection.path_budget_dbm << "],";
                }
                ss << "[]]";
                demo_file << "[" << ss.str() << "]";
                demo_file.close();
#endif        
                return true;
            }

            bool peaks(const arguments & args_, std::string & result) {
                std::stringstream filename;
                filename << "peaks" << ".sqf";
                std::ofstream demo_file("userconfig\\debug_signal\\" + filename.str());


                std::stringstream ss;
                ss.precision(16);
                for (auto peak : _map->peaks) {
                    ss << "[" << peak.x << "," << peak.y << "," << peak.z << "],";
                }
                ss << "[]";
                demo_file << "[" << ss.str() << "]";
                demo_file.close();
                return true;
            }

            bool load_antenna(const arguments &args_, std::string &result) {
                if (acre::signal::antenna_library::get().load_antenna(args_.as_string(0), args_.as_string(1))) {
                    result = "1";
                    return true;
                }
                result = "0";
                return true;
            }

            bool signal_map(arguments &args_, std::string &result) {
                _signal_map_progress = 0;

                std::string id = args_.as_string();
                float sample_size = (std::max)(std::floor(args_.as_float()), 1.0f);
                float x, y, z;

                x = args_.as_float();
                y = args_.as_float();
                z = args_.as_float();
                glm::vec3 start_pos = glm::vec3(x, y, z);

                x = args_.as_float();
                y = args_.as_float();
                z = args_.as_float();
                glm::vec3 end_pos = glm::vec3(x, y, z);

                x = args_.as_float();
                y = args_.as_float();
                z = args_.as_float();
                glm::vec3 tx_pos = glm::vec3(x, y, z);

                x = args_.as_float();
                y = args_.as_float();
                z = args_.as_float();
                glm::vec3 tx_dir = glm::vec3(x, y, z);

                float tx_antenna_height = args_.as_float();
                float rx_antenna_height = args_.as_float();

                tx_pos.z += tx_antenna_height;

                std::string tx_antenna_name = args_.as_string();
                std::string rx_antenna_name = args_.as_string();

                
                float f = args_.as_float();
                float power = args_.as_float();

                float lower_sensitivity = args_.as_float();
                float upper_sensitivity = args_.as_float();

                float start_x = start_pos.x;
                float start_y = start_pos.y;

                float width = (end_pos.x - start_pos.x);
                float height = (end_pos.y - start_pos.y);


                if (start_x + width > _map->cell_size()*_map->map_size()) {
                    width = width - ((_map->cell_size()*_map->map_size()) - (start_x + width));
                }

                if (start_y + height > _map->cell_size()*_map->map_size()) {
                    height = height - ((_map->cell_size()*_map->map_size()) - (start_y + height));
                }

                uint32_t count_x = (int)std::floor(width / sample_size);
                uint32_t count_y = (int)std::floor(height / sample_size);

                _total_signal_map_steps = count_x * count_y;

                

                acre::signal::antenna_p tx_antenna;
                acre::signal::antenna_p rx_antenna;

                if (!acre::signal::antenna_library::get().get_antenna(tx_antenna_name, tx_antenna)) {
                    result = "[]";
                    return true;
                }

                if (!acre::signal::antenna_library::get().get_antenna(rx_antenna_name, rx_antenna)) {
                    result = "[]";
                    return true;
                }

                uint32_t thread_count = 6;

                uint32_t y_chunk_size, y_chunk_remainder;
                if (count_y > thread_count) {
                    y_chunk_size = (uint32_t)std::floor(count_y / thread_count);
                    y_chunk_remainder = count_y % thread_count;
                }
                else {
                    y_chunk_size = 1;
                    thread_count = count_y;
                    y_chunk_remainder = 0;
                }
                std::vector<std::thread> thread_pool;
                std::vector<std::vector<signal_map_result>> result_sets;
                result_sets.resize(thread_count+1);

                for (uint32_t i = 0; i < thread_count; ++i) {
                    std::vector<signal_map_result> *result_entry = &result_sets[i];
                    result_entry->resize(y_chunk_size*count_x);
                    thread_pool.push_back(std::thread(&acre::signal::controller::signal_map_chunk, this, result_entry, start_y, start_x, y_chunk_size*i, y_chunk_size, count_x, sample_size,
                        rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f));
                }
                if (y_chunk_remainder) {
                    std::vector<signal_map_result> *result_entry = &result_sets[thread_count];
                    result_entry->resize(y_chunk_size*count_x);
                    thread_pool.push_back(std::thread(&acre::signal::controller::signal_map_chunk, this, result_entry, start_y, start_x, y_chunk_size*thread_count, y_chunk_remainder, count_x, sample_size,
                        rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f));
                }
                for (size_t c = 0; c < thread_pool.size(); ++c) {
                    thread_pool[c].join();
                }

                std::vector<uint8_t> png_data;
                png_data.resize(4096 * 4096 * 4);
                std::fill(png_data.begin(), png_data.end(), 0);
                int c = 0;
                std::vector<signal_map_result> total_results;
                for (auto results : result_sets) {
                    int y_count = 0;
                    for (uint32_t y = (c * y_chunk_size); y < (c * y_chunk_size) + y_chunk_size - 1; ++y) {
                        for (uint32_t x = 0; x < count_x; ++x) {
                            float s = results.at(y_count * count_x + x).result.result_dbm;
                            float p = _get_percentage(s, lower_sensitivity, upper_sensitivity);
                            draw_square(png_data, 4096, (uint32_t)sample_size, x, y, (uint8_t)(255 * (1.0f - p)), (uint8_t)(255 * p), 0, (uint8_t)(225 * p));
                        }
                        y_count++;
                    }
                    total_results.insert(std::end(total_results), std::begin(results), std::end(results));
                    c++;
                }
                lodepng::State state;
                state.encoder.auto_convert = false;
                std::vector<unsigned char> png;
                unsigned error = lodepng::encode(png, png_data, 4096, 4096, state);
                
                char path[FILENAME_MAX];
                _getcwd(path, sizeof(path));
                std::string output_path = std::string(path);
                output_path += "\\userconfig\\" + id + ".png";
                //GetModuleFileName(NULL, path, len);
                _signal_map_areas[id] = total_results;
                if (!error) lodepng::save_file(png, output_path.c_str());
                std::string encode_path = "P:\\TexView2\\Pal2PacE.exe \"" + output_path + "\"";
                system(encode_path.c_str());
                result = "";
                return true;
            }

            void draw_square(std::vector<uint8_t> &image_, uint32_t image_size_, uint32_t square_size_, uint32_t x_, uint32_t y_, uint8_t r_, uint8_t g_, uint8_t b_, uint8_t a_) {
                for (uint32_t y = y_*square_size_; y < y_*square_size_+square_size_; ++y) {
                    for (uint32_t x = x_*square_size_; x < x_*square_size_+square_size_; ++x) {
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 0] = r_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 1] = g_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 2] = b_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 3] = a_;
                    }
                }
            }

            void signal_map_chunk(std::vector<signal_map_result> *results, float start_y, float start_x, uint32_t y_offset, uint32_t length, uint32_t x_size, float sample_size,
                float rx_antenna_height, glm::vec3 tx_pos_, glm::vec3 tx_dir_, antenna_p &tx_antenna_, antenna_p &rx_antenna_, float frequency_, float power_, float sinad_
                ) {
                uint32_t y_val = 0;
                for (uint32_t y = y_offset; y < y_offset+length; ++y) {
                    if (stopped())
                        return;
                    for (uint32_t x = 0; x < x_size; ++x) {
                        if (stopped())
                            return;
                        float rx_x_pos = start_x + (float)(x*sample_size) + (sample_size / 2);
                        float rx_y_pos = start_y + (float)(y*sample_size) + (sample_size / 2);
                        float z = _map->elevation(rx_x_pos, rx_y_pos) + rx_antenna_height;
                        signal_map_result result;
                        result.rx_pos = glm::vec3(rx_x_pos, rx_y_pos, z);
                        result.tx_pos = glm::vec3(tx_pos_);
                        _signal_processor.process(&result.result, tx_pos_, tx_dir_, result.rx_pos, glm::vec3(0.0f, 1.0f, 0.0f), tx_antenna_, rx_antenna_, frequency_, power_, 1.0f, false);
                        results->at(y_val * x_size + x) = result;
                    }
                    y_val++;
                    std::lock_guard<std::mutex> lock(_signal_lock);
                    _signal_map_progress += x_size;
                }
            }

            bool signal_map_progress(arguments &args_, std::string &result) {
                std::lock_guard<std::mutex> lock(_signal_lock);
                std::stringstream ss;
                ss.precision(16);
                ss << "[" << _signal_map_progress << "," << _total_signal_map_steps << "]";
                result = ss.str();
                return true;
            }

            bool signal_map_get_sample_data(arguments &args_, std::string &result_) {
                std::string id = args_.as_string();
                uint32_t x = args_.as_uint32();
                uint32_t y = args_.as_uint32();
                uint32_t x_size = args_.as_uint32();
                uint32_t y_size = args_.as_uint32();

                result_ = "[]";
                if (_signal_map_areas.find(id) != _signal_map_areas.end()) {
                    auto result_set = _signal_map_areas[id];
                    if (result_set.size() > 0) {
                        auto result = result_set[y * x_size + x];
                        std::stringstream ss;
                        ss.precision(16);
                        ss << "[";
                        ss << "[" << result.tx_pos.x << "," << result.tx_pos.y << "," << result.tx_pos.z << "],";
                        ss << "[" << result.rx_pos.x << "," << result.rx_pos.y << "," << result.rx_pos.z << "],";
                        ss << result.result.result_dbm << ",";
                        ss << "[";
                        for (auto reflection : result.result.reflect_points) {
                            ss << "[";
                            ss << "[" << reflection.point.x << "," << reflection.point.y << "," << reflection.point.z << "],";
                            ss << "[" << reflection.normal.x << "," << reflection.normal.y << "," << reflection.normal.z << "],";
                            ss << reflection.phase << "," << reflection.reflect_coefficient << "," << reflection.path_budget_dbm;
                            ss << "],";
                        }
                        ss << "[]";
                        ss << "]";
                        ss << "]";
                        std::string result_string = ss.str();
                        if (result_string.length() <= 4096) {
                            result_ = ss.str();
                        }
                    }
                }
                return true;
            }
        };
        typedef std::shared_ptr<controller> controller_p;
    }
}
