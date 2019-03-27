#include "longleyRice.hpp"

#define WITH_POINT_TO_POINT
#include "longleyRice_itm.cpp"
#include "longleyRice_itwom3.0.cpp"

acre::signal::model::longleyRice::longleyRice(map_p map_) : SignalModel()
{
    _map = map_;
}

acre::signal::model::longleyRice::~longleyRice() {

}

void acre::signal::model::longleyRice::process(
        result *const result,
        const glm::vec3 &tx_pos,
        const glm::vec3 &tx_dir,
        const glm::vec3 &rx_pos,
        const glm::vec3 &rx_dir,
        const antenna_p &tx_antenna,
        const antenna_p &rx_antenna,
        const float32_t frequency_MHz,
        const float32_t power_mW,
        const bool useITWOM,
        const bool omnidirectional,
        const bool useClutterAttenuation) {

    if ((frequency_MHz < 20.0f) || (frequency_MHz > 20000.0f)) {
        // Frequency out of range
        result->result_v = dbm_to_v(-999.0f, 50.0f);
        result->result_dbm = -999.0f;
        return;
    }

    const acre_antennaPolarization_t polarization = tx_antenna->getPolarization();
    if (((polarization == acre_antennaPolarization_circular) && !useITWOM) || (polarization >= acre_antennaPolarization_num)) {
        // Antenna polarization not supported
        result->result_v = dbm_to_v(-999.0f, 50.0f);
        result->result_dbm = -999.0f;
        return;
    }
    const float64_t rxInternalLoss = static_cast<float64_t>(rx_antenna->getInternalLoss_dBm());
    const float64_t txInternalLoss = static_cast<float64_t>(tx_antenna->getInternalLoss_dBm());

    float64_t rxGain = 0.0;
    float64_t txGain = 0.0;
    if (!omnidirectional) {
        rxGain = static_cast<float64_t>(rx_antenna->gain(rx_dir, tx_pos - rx_pos, frequency_MHz));
        txGain = static_cast<float64_t>(tx_antenna->gain(tx_dir, rx_pos - tx_pos, frequency_MHz));
    }

    const float64_t txPower = static_cast<float64_t>(mW_to_dbm(power_mW));
    const float64_t linkBudget = txPower + txGain - txInternalLoss + rxGain - rxInternalLoss;

    const acre_mapClimate_t radioClimate = _map->getMapClimate();
    const float64_t eps_dielect= 15.0;         // TODO: Make it map dependent?
    const float64_t sgm_conductivity = 0.005;  // TODO: Make it map dependent?
    const float64_t eno = 301.0;               // TODO: Make it map dependent?
    const float64_t conf = 0.90;               // 90% of situations and time, take into account speed
    const float64_t rel = 0.90;

    float64_t dbloss = 0.0;
    char strmode[150];
    int32_t p_mode = static_cast<int32_t>(acre_itmPropagation_los);
    float64_t horizons[2] = {0.0, 0.0};
    int32_t errnum = 0;

    // Get elevation data and prepare it as ITM format
    std::vector<float64_t> itmElevations;
    const float32_t sampleSize = 7.5f;

    itmElevations.push_back(0.0);                                          // ITM: Number of points in the data - 1
    itmElevations.push_back(static_cast<float64_t>(sampleSize));           // ITM: Distance between points
    _map->terrain_profile(tx_pos, rx_pos, sampleSize, itmElevations);      // Get Terrain elevations
    itmElevations[0] = static_cast<float64_t>(itmElevations.size() - 1u);  // ITM: Update the number of points

    if (useITWOM) {
        acre::signal::model::itwom::point_to_point(itmElevations.data(), static_cast<float64_t>(rx_pos.z), static_cast<float64_t>(tx_pos.z),
                eps_dielect, sgm_conductivity, eno, static_cast<float64_t>(frequency_MHz), static_cast<int32_t>(radioClimate),
                static_cast<int32_t>(polarization), conf, rel, dbloss, strmode, p_mode, horizons, errnum);
    } else {
        acre::signal::model::itwom::point_to_point(itmElevations.data(), static_cast<float64_t>(rx_pos.z), static_cast<float64_t>(tx_pos.z),
                eps_dielect, sgm_conductivity, eno, static_cast<float64_t>(frequency_MHz), static_cast<int32_t>(radioClimate),
                static_cast<int32_t>(polarization), conf, rel, dbloss, strmode, p_mode, horizons, errnum);
    }

    float64_t clutterLoss = 0.0;
    if (useClutterAttenuation) {
        // TODO: Add clutter loss
        // Vegetation: ITU-R  P.833-7 (https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.833-7-201202-S!!PDF-E.pdf)
        // Urban Loss 1: https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-P.2402-2017-PDF-E.pdf
        // Urban Loss 300Mhz > https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.1411-6-201202-S!!PDF-E.pdf
        // Urban Loss. building entering (>100 MHz 343): https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.2040-1-201507-I!!PDF-E.pdf
        // 30 MHz to 3GHz (Point-to-Area) https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.1411-6-201202-S!!PDF-E.pdf
    }

    float64_t polarizationLoss = 0.0; // TODO: Add polarisation loss?

    const float32_t signalStrength = static_cast<float32_t>(linkBudget - dbloss - clutterLoss - polarizationLoss);

    result->result_v = dbm_to_v(signalStrength, 50.0f);
    result->result_dbm = signalStrength;
}
