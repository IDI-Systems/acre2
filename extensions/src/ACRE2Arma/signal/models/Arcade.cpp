#include "Arcade.hpp"
#include "glm\geometric.hpp"
#include "glm\gtx\vector_angle.hpp"

acre::signal::model::Arcade::Arcade()
{

}

acre::signal::model::Arcade::~Arcade()
{

}

void acre::signal::model::Arcade::process(result *result_, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const glm::vec3 &rx_pos_, const glm::vec3 &rx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, float frequency_, float power_, float scale_, bool omnidirectional_)
{
    // Implement model in http://acre2.idi-systems.com/wiki/frameworks/custom-signal-processing
}
