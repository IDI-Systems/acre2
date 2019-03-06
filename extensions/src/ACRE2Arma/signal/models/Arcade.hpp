#ifndef MODELS_ARCADE_HPP_
#define MODELS_ARCADE_HPP_

#include "models_common.hpp"

#include <string>

namespace acre {
    namespace signal {
        namespace model {
            class Arcade : public SignalModel {
            public:
                Arcade();
                ~Arcade();

                void process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &rx_pos_, const std::string &rx_antenna_name, const float32_t frequency_Hz, const float32_t power_mW);
            };
        }
    }
}

#endif /* MODELS_ARCADE_HPP_ */
