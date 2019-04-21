#ifndef MODELS_CASUAL_HPP_
#define MODELS_CASUAL_HPP_

#include "models_common.hpp"

#include <string>

namespace acre {
    namespace signal {
        namespace model {
            class Casual : public SignalModel {
            public:
                Casual();
                ~Casual();

                void process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &rx_pos_, const std::string &rx_antenna_name, const float32_t frequency_Hz, const float32_t power_mW);
            };
        }
    }
}

#endif /* MODELS_CASUAL_HPP_ */
