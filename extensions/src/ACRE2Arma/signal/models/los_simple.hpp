#pragma once

#include "models_common.hpp"
#include "../antenna/antenna.hpp"

#include <map>

namespace acre {
    namespace signal {
        namespace model {
            class los_simple : public SignalModel {
            public:
                los_simple() {}
                los_simple(map_p);
                ~los_simple();

                void process(result *const result, const glm::vec3 &tx_pos, const glm::vec3 &tx_dir, const glm::vec3 &rx_pos, const glm::vec3 &rx_dir, const antenna_p &tx_antenna, const antenna_p &rx_antenna, const float32_t frequency, const float32_t power, const float32_t scale, const bool omnidirectional);

                float32_t itu(const float32_t h, const float32_t d1_km, float32_t d2_km, float32_t f_GHz);
                float32_t diffraction_loss(const glm::vec3 &pos1, const glm::vec3 &pos2, const float32_t frequency);
            };

            class multipath : public los_simple {
            public:
                multipath() {}
                multipath(map_p);
                ~multipath();

                void process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const glm::vec3 &rx_pos_, const glm::vec3 &rx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, const float32_t frequency_, const float32_t power_, const float32_t scale_, const bool omnidirectional_);

            protected:
                void get_peaks_spiral(const float32_t pos_x, const float32_t pos_y, const int32_t size_x, const int32_t size_y, std::vector<glm::vec3> &peaks);
                std::vector<std::vector<glm::vec3>> _peak_buckets;

                float32_t phase(const float32_t path_distance, const float32_t f_Mhz);
                float32_t phase_amplitude(const float32_t a1, const float32_t a2, const float32_t phase);
                float32_t search_distance(const float32_t frequency_Hz, const float32_t power_mW);
                std::map<float32_t, std::map<float32_t, float32_t>> _distance_cache;
                glm::vec3 _cached_tx_pos;
                std::vector<glm::vec3> _cached_peaks;
            };
        }
    }
}
