#pragma once

#include "shared.hpp"
#include "glm/vec3.hpp"
#include "glm/vec2.hpp"
#include "singleton.hpp"
#include "pbo/search.hpp"
#include "membuf.hpp"
#include "wrp/landscape.hpp"
#include "pbo/fileloader.hpp"

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
            map(std::string, uint32_t, float);
            map(std::string);
            map(std::string, bool);
            map(acre::wrp::landscape_p);
            ~map();

            void load_asc_header(std::string);

            float elevation(float, float, float *, float *);
            float elevation(float, float);

            float elevation_raw(int x_, int y_) { return _internal_elevation(x_, y_); };
            //float elevation_fast(float, float);
            glm::vec3 normal(float, float);

            float cell_size() { return _cell_size; }
            uint32_t map_size() { return _map_size; }

            bool ground_intersect(const glm::vec3, const glm::vec3, const float);
            bool ground_intersect(const glm::vec3, const glm::vec3, const float, glm::vec3 &);

            void terrain_profile(glm::vec3, glm::vec3, float, std::vector<float> &);

            void write_cache(std::string);
            std::unordered_map<std::string, double> asc_header;
            std::vector<glm::vec3> peaks;
        protected:
            float *_map_elevations;
            uint32_t _map_size;
            float _cell_size;
            float _inv_cell_size;

            void _generate_peaks();

            float _internal_elevation(const int, const int);
            std::vector<glm::vec2> _grids_on_line(float, float, float, float);
            float _max_grid_height(int, int);
            bool _is_peak(int, int);
        };
    }
}
