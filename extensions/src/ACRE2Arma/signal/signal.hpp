#pragma once

#include <algorithm>
#include "shared.hpp"
#include "controller.hpp"
#include <sstream>
#include "map/map.hpp"

#include "models/arcade.hpp"
#include "models/longleyRice.hpp"
#include "models/los_simple.hpp"

#include "antenna/antenna_library.hpp"
#include "lodepng.h"

#ifdef _WINDOWS
#include <direct.h>
#endif

namespace acre {
    namespace signal {
        enum class PropagationModel {
             arcade,
             los,
             losMultipath,
             longleyRice_itm,
             longleyRice_itwom,
             underwater
        };

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

            acre::signal::model::Arcade      _signalProcessor_arcade;
            acre::signal::model::los_simple  _signalProcessor_los;
            acre::signal::model::multipath   _signalProcessor_multipath;
            acre::signal::model::longleyRice _signalProcessor_longleyRice;

            uint32_t _total_signal_map_steps;
            volatile uint32_t _signal_map_progress;
            std::mutex _signal_lock;

            std::map<std::string, std::vector<signal_map_result>> _signal_map_areas;

            float32_t _get_percentage(const float32_t s_, const float32_t min_, const float32_t max_) {
                return (std::min)((std::max)(((s_ - min_) / (max_ - min_)), 0.0f), 1.0f);
            }
        public:
            typedef enum {
                acre_signalArgument_signalPropagationModel,
                acre_signalArgument_id,
                acre_signalArgument_txPositionX,
                acre_signalArgument_txPositionY,
                acre_signalArgument_txPositionZ,
                acre_signalArgument_txDirectionX,
                acre_signalArgument_txDirectionY,
                acre_signalArgument_txDirectionZ,
                acre_signalArgument_txAntennaName,
                acre_signalArgument_rxPositionX,
                acre_signalArgument_rxPositionY,
                acre_signalArgument_rxPositionZ,
                acre_signalArgument_rxDirectionX,
                acre_signalArgument_rxDirectionY,
                acre_signalArgument_rxDirectionZ,
                acre_signalArgument_rxAntennaName,
                acre_signalArgument_frequency,
                acre_signalArgument_power,
                acre_signalArgument_terrainScaling,
                acre_signalArgument_tickTime,
                acre_signalArgument_debugEnabled,
                acre_signalArgument_omnidirectionalRadios,
                acre_signalArgument_numArguments
            } acre_signalArgument_t;

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
                LOG(INFO) << "Attempting to load map from PBO...";
                acre::wrp::LandscapeResult map_load_result = acre::signal::map_loader::get().get_map(args_.as_string(0), _map, loaded);
                if (map_load_result > acre::wrp::LandscapeResult::Failure) { //Return 0 = OKAY, -1 RECOVERD, -2 FAILURE
                    LOG(INFO) << "Map Loaded, Error Status: " << static_cast<int32_t>(map_load_result);
                    if (!loaded) {
                        LOG(INFO) << "Adding signal processing to map...";
                        _map->setMapClimate(static_cast<acre::signal::MapClimate>(args_.as_int(1)));

                        _signalProcessor_multipath = acre::signal::model::multipath(_map);
                        _signalProcessor_los = acre::signal::model::los_simple(_map);
                        _signalProcessor_longleyRice = acre::signal::model::longleyRice(_map);
                        LOG(INFO) << "Finished adding signal processor to map.";
                    } else {
                        LOG(INFO) << "Reloaded current map.";
                    }
                } else {
                    LOG(INFO) << "ERROR Map Loading, Error Code: " << static_cast<int32_t>(map_load_result);
                }
                result = std::to_string(static_cast<int32_t>(map_load_result));
                return true;
            }
            //#define DEBUG_OUTPUT
            bool process(const arguments & args_, std::string & result) {
                if (args_.size() != acre_signalArgument_numArguments) {
                    result = "[]";
                    return true;
                }

                const PropagationModel model = static_cast<PropagationModel>(args_.as_int(acre_signalArgument_signalPropagationModel));

                const int32_t logging = args_.as_int(acre_signalArgument_debugEnabled);
                const bool omnidirectional = args_.as_int(acre_signalArgument_omnidirectionalRadios);

                const std::string id = args_.as_string(acre_signalArgument_id);
                const glm::vec3 tx_pos = glm::vec3(args_.as_float(acre_signalArgument_txPositionX),
                                                   args_.as_float(acre_signalArgument_txPositionY),
                                                   args_.as_float(acre_signalArgument_txPositionZ));
                const glm::vec3 tx_dir = glm::vec3(args_.as_float(acre_signalArgument_txDirectionX),
                                                   args_.as_float(acre_signalArgument_txDirectionY),
                                                   args_.as_float(acre_signalArgument_txDirectionZ));
                const std::string tx_antenna_name = args_.as_string(acre_signalArgument_txAntennaName);
                const glm::vec3 rx_pos = glm::vec3(args_.as_float(acre_signalArgument_rxPositionX),
                                                   args_.as_float(acre_signalArgument_rxPositionY),
                                                   args_.as_float(acre_signalArgument_rxPositionZ));
                const glm::vec3 rx_dir = glm::vec3(args_.as_float(acre_signalArgument_rxDirectionX),
                                                   args_.as_float(acre_signalArgument_rxDirectionY),
                                                   args_.as_float(acre_signalArgument_rxDirectionZ));
                const std::string rx_antenna_name = args_.as_string(acre_signalArgument_rxAntennaName);

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

                const float32_t frequency_MHz = args_.as_float(acre_signalArgument_frequency);
                const float32_t power_mW = args_.as_float(acre_signalArgument_power);
                const float32_t scale = args_.as_float(acre_signalArgument_terrainScaling);

                acre::signal::result signal_result;

                switch (model) {
                    case PropagationModel::arcade: {
                        _signalProcessor_arcade.process(&signal_result, tx_pos, rx_pos, rx_antenna_name, frequency_MHz, power_mW);
                        break;
                    }
                    case PropagationModel::los: {
                        _signalProcessor_los.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, frequency_MHz, power_mW, scale, omnidirectional);
                        break;
                    }
                    case PropagationModel::losMultipath: {
                        _signalProcessor_multipath.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, frequency_MHz, power_mW, scale, omnidirectional);
                        break;
                    }
                    case PropagationModel::longleyRice_itm: {
                        _signalProcessor_longleyRice.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, frequency_MHz, power_mW, false, omnidirectional, true);
                        break;
                    }
                    case PropagationModel::longleyRice_itwom: {
                        _signalProcessor_longleyRice.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, frequency_MHz, power_mW, true, omnidirectional, true);
                        break;
                    }
                    default: {
                        _signalProcessor_multipath.process(&signal_result, tx_pos, tx_dir, rx_pos, rx_dir, tx_antenna, rx_antenna, frequency_MHz, power_mW, scale, omnidirectional);
                    }
                }

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

            bool peaks(const arguments & args_, const std::string &result) {
                (void) result;

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

                const std::string id = args_.as_string();
                const float32_t sample_size = (std::max)(std::floor(args_.as_float()), 1.0f);

                float32_t x = args_.as_float();
                float32_t y = args_.as_float();
                float32_t z = args_.as_float();
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

                const float32_t tx_antenna_height = args_.as_float();
                const float32_t rx_antenna_height = args_.as_float();

                tx_pos.z += tx_antenna_height;

                const std::string tx_antenna_name = args_.as_string();
                const std::string rx_antenna_name = args_.as_string();

                const float32_t f = args_.as_float();
                const float32_t power = args_.as_float();

                const float32_t lower_sensitivity = args_.as_float();
                const float32_t upper_sensitivity = args_.as_float();
                const bool omnidirectional = args_.as_int();

                const float32_t start_x = start_pos.x;
                const float32_t start_y = start_pos.y;

                float32_t width = (end_pos.x - start_pos.x);
                float32_t height = (end_pos.y - start_pos.y);

                if (start_x + width > _map->cell_size()*_map->map_size()) {
                    width = width - ((_map->cell_size()*_map->map_size()) - (start_x + width));
                }

                if (start_y + height > _map->cell_size()*_map->map_size()) {
                    height = height - ((_map->cell_size()*_map->map_size()) - (start_y + height));
                }

                const uint32_t count_x = (int32_t)std::floor(width / sample_size);
                const uint32_t count_y = (int32_t)std::floor(height / sample_size);

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

                uint32_t thread_count = 1;

                uint32_t y_chunk_size, y_chunk_remainder;
                if (count_y > thread_count) {
                    y_chunk_size = (uint32_t)std::floor(count_y / thread_count);
                    y_chunk_remainder = count_y % thread_count;
                } else {
                    y_chunk_size = 1;
                    thread_count = count_y;
                    y_chunk_remainder = 0;
                }
                std::vector<std::thread> thread_pool;
                std::vector<std::vector<signal_map_result>> result_sets;
                result_sets.resize(thread_count);

                for (uint32_t i = 0; i < thread_count; ++i) {
                    std::vector<signal_map_result> *result_entry = &result_sets[i];
                    result_entry->resize(y_chunk_size*count_x);
                    thread_pool.push_back(std::thread(&acre::signal::controller::signal_map_chunk, this, result_entry, start_y, start_x, y_chunk_size*i, y_chunk_size, count_x, sample_size,
                        rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f, omnidirectional));
                }

                if (y_chunk_remainder) {
                    std::vector<signal_map_result> *result_entry = &result_sets[thread_count];
                    result_entry->resize(y_chunk_size*count_x);
                    thread_pool.push_back(std::thread(&acre::signal::controller::signal_map_chunk, this, result_entry, start_y, start_x, y_chunk_size*thread_count, y_chunk_remainder, count_x, sample_size,
                        rx_antenna_height, tx_pos, tx_dir, tx_antenna, rx_antenna, f, power, 12.0f, omnidirectional));
                }

                for (size_t c = 0; c < thread_pool.size(); ++c) {
                    thread_pool[c].join();
                }

                std::vector<uint8_t> png_data;
                png_data.resize(4096 * 4096 * 4);
                std::fill(png_data.begin(), png_data.end(), 0);
                int32_t c = 0;
                std::vector<signal_map_result> total_results;
                for (auto results : result_sets) {
                    int32_t y_count = 0;
                    for (uint32_t y = (c * y_chunk_size); y < (c * y_chunk_size) + y_chunk_size - 1; ++y) {
                        for (uint32_t x = 0; x < count_x; ++x) {
                            const float32_t s = results.at(y_count * count_x + x).result.result_dbm;
                            const float32_t p = _get_percentage(s, lower_sensitivity, upper_sensitivity);
                            draw_square(png_data, 4096, static_cast<uint32_t>(sample_size), x, y, static_cast<uint8_t>(255.0f * (1.0f - p)), static_cast<uint8_t>(255.0f * p), 0, static_cast<uint8_t>(225.0f * p));
                        }
                        y_count++;
                    }
                    total_results.insert(std::end(total_results), std::begin(results), std::end(results));
                    c++;
                }
                lodepng::State state;
                state.encoder.auto_convert = false;
                std::vector<unsigned char> png;
                const uint32_t error = lodepng::encode(png, png_data, 4096u, 4096u, state);

                char path[FILENAME_MAX];
                _getcwd(path, sizeof(path));
                std::string output_path = std::string(path);
                output_path += "\\userconfig\\" + id + ".png";
                //GetModuleFileName(NULL, path, len);
                _signal_map_areas[id] = total_results;
                if (!error) {
                    lodepng::save_file(png, output_path.c_str());
                }
                std::string encode_path = "P:\\TexView2\\Pal2PacE.exe \"" + output_path + "\"";
                system(encode_path.c_str());
                result = "";
                return true;
            }

            void draw_square(std::vector<uint8_t> &image_, const uint32_t image_size_, const uint32_t square_size_, const uint32_t x_, const uint32_t y_, const uint8_t r_, const uint8_t g_, const uint8_t b_, const  uint8_t a_) {
                for (uint32_t y = y_*square_size_; y < y_*square_size_+square_size_; ++y) {
                    for (uint32_t x = x_*square_size_; x < x_*square_size_+square_size_; ++x) {
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 0] = r_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 1] = g_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 2] = b_;
                        image_[4 * image_size_ * ((image_size_ - 1) - y) + 4 * x + 3] = a_;
                    }
                }
            }

            void signal_map_chunk(std::vector<signal_map_result> *results, const float32_t start_y, const float32_t start_x, const uint32_t y_offset, const uint32_t length, const uint32_t x_size, const float32_t sample_size,
                                  const float32_t rx_antenna_height, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, const float32_t frequency_, const float32_t power_, const float32_t sinad_, const bool omnidirectional_) {
                uint32_t y_val = 0;
                for (uint32_t y = y_offset; y < y_offset+length; ++y) {
                    if (stopped()) {
                        return;
                    }
                    for (uint32_t x = 0; x < x_size; ++x) {
                        if (stopped()) {
                            return;
                        }
                        const float32_t rx_x_pos = start_x + (static_cast<float32_t>(x)*sample_size) + (sample_size / 2.0f);
                        const float32_t rx_y_pos = start_y + (static_cast<float32_t>(y)*sample_size) + (sample_size / 2.0f);
                        const float32_t z = _map->elevation(rx_x_pos, rx_y_pos) + rx_antenna_height;
                        signal_map_result result;
                        result.rx_pos = glm::vec3(rx_x_pos, rx_y_pos, z);
                        result.tx_pos = glm::vec3(tx_pos_);
                        _signalProcessor_multipath.process(&result.result, tx_pos_, tx_dir_, result.rx_pos, glm::vec3(0.0f, 1.0f, 0.0f), tx_antenna_, rx_antenna_, frequency_, power_, 1.0f, omnidirectional_);
                        {
                            std::lock_guard<std::mutex> lock(_signal_lock);
                            results->at(y_val * x_size + x) = result;
                        }
                    }
                    y_val++;
                    std::lock_guard<std::mutex> lock(_signal_lock);
                    _signal_map_progress += x_size;
                }
            }

            bool signal_map_progress(const arguments &args_, std::string &result) {
                (void) args_;

                std::lock_guard<std::mutex> lock(_signal_lock);
                std::stringstream ss;
                ss.precision(16);
                ss << "[" << _signal_map_progress << "," << _total_signal_map_steps << "]";
                result = ss.str();
                return true;
            }

            bool signal_map_get_sample_data(arguments &args_, std::string &result_) {
                const std::string id = args_.as_string();
                const uint32_t x = args_.as_uint32();
                const uint32_t y = args_.as_uint32();
                const uint32_t x_size = args_.as_uint32();
                const uint32_t y_size = args_.as_uint32();

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
