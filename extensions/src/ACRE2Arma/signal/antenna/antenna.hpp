#ifndef ANTENNA_ANTENNA_HPP_
#define ANTENNA_ANTENNA_HPP_

#include "Types.h"

#include <iostream>
#include <memory>
#include <glm/vec3.hpp>

namespace acre {
    namespace signal {

        typedef enum {
            acre_antennaPolarization_horizontal,
            acre_antennaPolarization_vertical,
            acre_antennaPolarization_circular,
            acre_antennaPolarization_num
        } acre_antennaPolarization_t;

        struct antenna_gain_entry {
            antenna_gain_entry() : v(0.0f), h(0.0f) {};
            float32_t v, h;
        };

        class antenna {
        public:
            antenna() : _gain_map(nullptr), _min_frequency(0.0f), _max_frequency(0.0f), _frequency_step(0.0f), _elevation_step(0.0f), _direction_step(0.0f),
                _total_entries(0), _width(0), _height(0), _polarization(acre_antennaPolarization_vertical) , _internalLos_dBm(3.0f){ };
            antenna(std::istream & stream_, const acre_antennaPolarization_t polarization_, const float32_t internalLoss_dBm_ );
            antenna(std::istream &stream_) : antenna(stream_, acre_antennaPolarization_vertical, 3.0f) {};

            ~antenna() {
                if (_gain_map != nullptr) {
                    delete[] _gain_map;
                }
            };

            float32_t gain(const glm::vec3 dir_antenna_, const glm::vec3 dir_signal_, const float32_t f_);

            acre_antennaPolarization_t getPolarization();
            void setPolarization(const acre_antennaPolarization_t polarization_);

            float32_t getInternalLoss_dBm();
            void setInternalLoss_dBm(const float32_t internalLos_dBm_);

        protected:
            float32_t _min_frequency, _max_frequency, _frequency_step, _elevation_step, _direction_step;
            uint32_t _total_entries, _width, _height;

            acre_antennaPolarization_t _polarization;
            float32_t                  _internalLos_dBm;

            antenna_gain_entry *_gain_map;

            float32_t _get_gain(const float32_t f_, const float32_t dir_, const float32_t elev_);
            float32_t _interp(const float32_t g_, const float32_t g1_, const float32_t g2_, const float32_t d1_, const float32_t d2_);
        };
        typedef std::shared_ptr<antenna> antenna_p;
    }
}

#endif /* ANTENNA_ANTENNA_HPP_ */
