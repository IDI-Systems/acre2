#pragma once

#include "shared.hpp"
#include "glm/vec3.hpp"
#include "glm/vec2.hpp"
#include "antenna/antenna.hpp"
#include "map/map.hpp"
#include "models_common.hpp"

namespace acre {
    namespace signal {
        namespace model {
            class Arcade : public SignalModel {
            public:
                Arcade();
                ~Arcade();

                void acre::signal::model::Arcade::process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &rx_pos_, const std::string &rx_antenna_name, const float frequency_Hz, const float power_mW);
            };
        }
    }
}
