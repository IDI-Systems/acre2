#ifndef ACRE2ARMA_SIGNAL_MODELS_ITM_HPP_
#define ACRE2ARMA_SIGNAL_MODELS_ITM_HPP_

#define WITH_POINT_TO_POINT

#include "models_common.hpp"
#include "../antenna/antenna.hpp"

#include <map>

namespace acre {
    namespace signal {
        namespace model {
            class itm : public SignalModel {
            public:
                itm() {};
                itm(map_p map);
                ~itm();

                void process(result *const result, const glm::vec3 &tx_pos, const glm::vec3 &tx_dir, const glm::vec3 &rx_pos, const glm::vec3 &rx_dir, const antenna_p &tx_antenna, const antenna_p &rx_antenna, const float32_t frequency, const float32_t power, const float32_t scale, const bool omnidirectional, const bool useClutterAttenuation);
            protected:
#include "itmCalc.cpp"
                typedef enum {
                    acre_itmPropagation_los,
                    acre_itmPropagation_diffraction,
                    acre_itmProgatagion_troposcatter
                } acre_itmPropagation_t;
            };
        }
    }
}

#endif /* ACRE2ARMA_SIGNAL_MODELS_ITM_HPP_ */
