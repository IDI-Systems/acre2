#include "itm.hpp"

acre::signal::model::itm::itm(map_p map_) : SignalModel()
{
    _map = map_;
}

acre::signal::model::itm::~itm() {

}

void acre::signal::model::itm::process(
        result *const result,
        const glm::vec3 &tx_pos,
        const glm::vec3 &tx_dir,
        const glm::vec3 &rx_pos,
        const glm::vec3 &rx_dir,
        const antenna_p &tx_antenna,
        const antenna_p &rx_antenna,
        const float32_t frequency_MHz,
        const float32_t power_mW,
        const float32_t scale,
        const bool omnidirectional,
        const bool useClutterAttenuation) {

    if ((frequency_MHz < 20.0f) || (frequency_MHz > 20000.0f)) {
        // Frequency out of range
        return;// frequency out of recommended range
    }

    // TODO: Make it map dependent
    const acre_mapClimate_t radioClimate = acre_mapClimate_continentalTemperate;
    const float64_t eps_dielect= 15.0;
    const float64_t sgm_conductivity = 0.005;
    const float64_t eno = 301.0;


    // TODO: Make it antenna dependent
    const acre_antennaPolarization_t polarization = acre_antennaPolarization_vertical;
    const float64_t tx_internal_loss = 3.0;
    const float64_t rx_internal_loss = 3.0;

    float64_t rx_gain = 0.0;
    float64_t tx_gain = 0.0;
    if (!omnidirectional) {
        rx_gain = rx_antenna->gain(rx_dir, tx_pos - rx_pos, frequency_MHz);
        tx_gain = tx_antenna->gain(tx_dir, rx_pos - tx_pos, frequency_MHz);
    }

    const float64_t tx_power = mW_to_dbm(power_mW);
    const float64_t linkBudget = tx_power + tx_gain - tx_internal_loss + rx_gain - rx_internal_loss;

    float64_t conf = 0.90; // 90% of situations and time, take into account speed
    float64_t rel = 0.90;

    float64_t dbloss = 0.0;
    char strmode[150];
    int32_t p_mode = static_cast<int32_t>(acre_itmPropagation_los);
    float64_t horizons[2];
    int32_t errnum;

    // Get elevation data
    std::vector<float64_t> elevation;

    acre::signal::model::itm::point_to_point(elevation.data(), static_cast<float64_t>(rx_pos.z), static_cast<float64_t>(tx_pos.z),
            eps_dielect, sgm_conductivity, eno, static_cast<float64_t>(frequency_MHz), static_cast<int32_t>(radioClimate),
            static_cast<int32_t>(polarization), conf, rel, dbloss, strmode, p_mode, horizons, errnum);

    float64_t clutterLoss = 0.0;
    if (useClutterAttenuation) {
        // TODO: Add clutter loss
    }

    float64_t polarisationLoss = 0.0; // TODO: Add polarisation loss?

    const float32_t signalStrength = linkBudget - dbloss - clutterLoss + polarisationLoss;

    result->result_v = dbm_to_v(signalStrength, 50.0f);
    result->result_dbm = signalStrength;

}

