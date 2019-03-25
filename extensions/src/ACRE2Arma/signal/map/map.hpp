#ifndef MAP_MAP_HPP_
#define MAP_MAP_HPP_

#include "Types.h"
#include "singleton.hpp"
#include "wrp/landscape.hpp"
#include "pbo/fileloader.hpp"

#include <glm/vec3.hpp>
#include <glm/vec2.hpp>

namespace acre {
    namespace signal {

        typedef enum {
            acre_mapClimate_equatorial = 1,
            acre_mapClimate_continentalSubropical,
            acre_mapClimate_maritimeTropical,
            acre_mapClimate_desert,
            acre_mapClimate_continentalTemperate,
            acre_mapClimate_maritimeTemperate,
            acre_mapClimate_overLand,
            acre_mapClimate_maritimeTemerateOverSea
        } acre_mapClimate_t;

        class map;
        typedef std::shared_ptr<map> map_p;

        class map_loader : public singleton<map_loader> {
        public:
            map_loader() {};
            ~map_loader() {};
            int32_t get_map(const std::string wrp_path_, map_p &result_, bool &loaded_) {
                //Return 0 = OKAY, -1 RECOVERD, -2 FAILURE
                if (wrp_path_ == _current_map && _map != nullptr) {
                    result_ = _map;
                    loaded_ = true;
                    return 0;
                }
                loaded_ = false;
                acre::pbo::file_entry_p wrp_file;
                if (acre::pbo::fileloader::get().get_file(wrp_path_, "wrp", wrp_file)) {
                    acre::wrp::landscape_p landscape = std::make_shared<acre::wrp::landscape>(wrp_file->stream());
                    result_ = std::make_shared<map>(landscape);
                    _current_map = wrp_path_;
                    return landscape.get()->failure;
                }

                LOG(ERROR) << "WRP unable to find wrp file: " << wrp_path_;
                return -2;
            };

        protected:
            std::string _current_map;
            map_p _map;
        };

        class map {
        public:
            map();
            map(const std::string xyz_path_, const uint32_t map_size_, const float32_t cell_size_, acre_mapClimate_t mapClimate_);
            map(const std::string xyz_path_, const uint32_t map_size_, const float32_t cell_size_) : map(xyz_path_, map_size_, cell_size_, acre_mapClimate_continentalTemperate) {}
            map(const std::string bin_path_);
            map(const std::string asc_path_, const bool use_degrees_);
            map(const acre::wrp::landscape_p);
            ~map();

            void load_asc_header(const std::string &ascHeaderPath);

            float32_t elevation(const float32_t x_, const float32_t y_, float32_t *const rd_x_, float32_t *const rd_y_);
            float32_t elevation(const float32_t x_, const float32_t y_);

            float32_t elevation_raw(const int32_t x_, const int32_t y_) { return _internal_elevation(x_, y_); };
            glm::vec3 normal(const float32_t x_, const float32_t y_);

            float32_t cell_size() const { return _cell_size; };
            uint32_t map_size() const { return _map_size; };

            bool ground_intersect(const glm::vec3 &origin_, const glm::vec3 dir_, const float32_t max_distance_);
            bool ground_intersect(const glm::vec3 &origin_, const glm::vec3 dir_, const float32_t max_distance_, glm::vec3 &result_)

            void terrain_profile(const glm::vec3 &start_pos_, const glm::vec3 &end_pos_, const float32_t precision_, std::vector<float32_t> &profile_);
            void terrain_profile(const glm::vec3 &start_pos_, const glm::vec3 &end_pos_, const float32_t precision_, std::vector<float64_t> &profile_);

            acre_mapClimate_t getMapClimate();
            void setMapClimate(const acre_mapClimate_t mapClimate);

            void write_cache(const std::string &bin_path_);
            std::unordered_map<std::string, float64_t> asc_header;
            std::vector<glm::vec3> peaks;
        protected:
            float32_t        *_map_elevations;
            uint32_t          _map_size;
            float32_t         _cell_size;
            float32_t         _inv_cell_size;
            acre_mapClimate_t _mapClimate;

            void _generate_peaks();

            float32_t _internal_elevation(const int32_t x_, const int32_t y_);
            std::vector<glm::vec2> _grids_on_line(const float32_t x1_, const float32_t y1_, const float32_t x2_, const float32_t y2_);
            float32_t _max_grid_height(const int32_t x_, const int32_t y_);
            bool _is_peak(const int32_t x_, const int32_t y_);
        };
    }
}

#endif /* MAP_MAP_HPP_ */
