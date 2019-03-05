#pragma once

#include "shared.hpp"
#include "map/map.hpp"
#include "glm/vec2.hpp"
#include "antenna/antenna.hpp"
#include "models_common.hpp"

//#define PHASE_EQ(d) ((6.28318530718f*(d) / (300.0f / f_mhz_)))
static const float PI = 3.14159265f;

namespace acre {
    namespace signal {
        namespace model {
            class los_simple : public acre::signal::SignalModel {
            public:
                los_simple() {};
                los_simple(map_p);
                ~los_simple();

                void process(result *, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const antenna_p &, const antenna_p &, float, float, float, bool);

                float _itu(float, float, float, float);
                float _diffraction_loss(glm::vec3, glm::vec3, float);

            };

            class multipath : public los_simple {
            public:
                multipath() {};
                multipath(map_p);
                ~multipath();

                void process(result *, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const glm::vec3 &, const antenna_p &, const antenna_p &, float, float, float, bool);

            protected:

                void _get_peaks_spiral(float, float, int, int, std::vector<glm::vec3> &);
                std::vector<std::vector<glm::vec3>> _peak_buckets;
                float _phase(const float path_distance_, const float f_mhz_) {
                    const float phase = PI*2.0f*path_distance_ / (300.0f / f_mhz_);
                    return fmod(phase, PI * 2) - PI;
                }
                float _phase_amplitude(const float a1_, const float a2_, const float phase_) {
                    return sqrtf(std::pow(a1_, 2.0f) + std::pow(a2_, 2.0f) + 2.0f*a1_*a2_*cos(phase_));
                }
                float _search_distance(float, float);
                std::map<float, std::map<float, float>> _distance_cache;
                glm::vec3 _cached_tx_pos;
                std::vector<glm::vec3> _cached_peaks;
            };
        }
    }
}
