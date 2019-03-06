#pragma once

#include "shared.hpp"

#include <glm/vec3.hpp>
#include <glm/vec2.hpp>

namespace acre {
    namespace signal {

        struct antenna_gain_entry {
            antenna_gain_entry() : v(0.0f), h(0.0f) {};
            float v, h;
        };

        class antenna {
        public:
            antenna() : _gain_map(NULL), _min_frequency(0.0f), _max_frequency(0.0f), _frequency_step(0.0f), _elevation_step(0.0f), _direction_step(0.0f),
                _total_entries(0), _width(0), _height(0) { };
            antenna(std::istream &stream_);
            ~antenna() {
                if (_gain_map != NULL)
                    delete[] _gain_map;
            };

            float gain(glm::vec3, glm::vec3, float);
        protected:
            float _min_frequency, _max_frequency, _frequency_step, _elevation_step, _direction_step;
            uint32_t _total_entries, _width, _height;
            antenna_gain_entry *_gain_map;

            float _get_gain(float, float, float);
            float _interp(float, float, float, float, float);
        };
        typedef std::shared_ptr<antenna> antenna_p;
    }
}
