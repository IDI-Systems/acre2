#include "Arcade.hpp"
#include "glm/geometric.hpp"
#include "glm/gtx/vector_angle.hpp"

acre::signal::model::Arcade::Arcade()
{

}

acre::signal::model::Arcade::~Arcade()
{

}

void acre::signal::model::Arcade::process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &rx_pos_, const std::string &rx_antenna_name, const float frequency_Hz, const float power_mW)
{
    const float distance_3d = glm::distance(tx_pos_, rx_pos_);

    // Free Space Path Loss model
    float lossFreeSpace = -27.55f + 20.0f*std::log10f(frequency_Hz) + 20.0f*std::log10f(distance_3d); /* Free Space Path Loss model */
    const float tx_power = 10.0f*(std::log10f((power_mW) / 1000.0f)) + 30.0f; /* Transmitter Power (mW to dBm) */

    if (rx_antenna_name.find("ACRE_2HALFINCH_UHF_TNC") != std::string::npos) {
        lossFreeSpace = lossFreeSpace - 17.0f;  // 17 dB boost.                   
    };

    const float _ituLoss = 36.0f; /* base loss level (based on empirical testing...) */

     /* Transmitter/Receiver cable/internal loss. */
    const float lossTx = 3.0f; /* Transmitter */
    const float lossRx = 3.0f; /* Receiver */

    /* Loss from fading, obstruction, noise, etc (including ITU model) */
    const float lossModel = _ituLoss + ((float) rand() / ((float) RAND_MAX + 1.0f) - 0.5f);

    /* Total Link Budget - SIGNAL STRENGTH */
    const float _linkBudget = tx_power - lossTx - lossFreeSpace - lossModel - lossRx; /* Assume antenna gain is 0 for both*/

    result_->result_v = _dbm_to_v(_linkBudget, 50.0f);
    result_->result_dbm = _linkBudget;
}
