#include "antenna.hpp"

#include "glm\geometric.hpp"
#include "glm\gtx\intersect.hpp"
#include "glm\gtx\normal.hpp"

acre::signal::antenna::antenna(std::istream & stream_)
{
    stream_.read((char *)&_min_frequency, sizeof(float));
    stream_.read((char *)&_max_frequency, sizeof(float));
    stream_.read((char *)&_frequency_step, sizeof(float));

    stream_.read((char *)&_total_entries, sizeof(uint32_t));
    stream_.read((char *)&_width, sizeof(uint32_t));
    stream_.read((char *)&_height, sizeof(uint32_t));

    stream_.read((char *)&_elevation_step, sizeof(uint32_t));
    stream_.read((char *)&_direction_step, sizeof(uint32_t));

    uint32_t map_size = _width * _height * _total_entries;

    _gain_map = new antenna_gain_entry[map_size];

    stream_.read((char *)_gain_map, sizeof(antenna_gain_entry)*map_size);
}

float acre::signal::antenna::gain(const glm::vec3 dir_antenna_, const glm::vec3 dir_signal_, const float f_)
{
    if (f_ < _min_frequency || f_ + _frequency_step > _max_frequency)
        return -1000.0f;

    glm::vec3 dir_antenna_v = glm::normalize(dir_antenna_);
    float elev_antenna = asinf(dir_antenna_v.z)*57.2957795f;
    float dir_antenna = atan2f(dir_antenna_v.x, dir_antenna_v.y)*57.2957795f;

    glm::vec3 dir_signal_v = glm::normalize(dir_signal_);
    float elev_signal = asinf(dir_signal_v.z)*57.2957795f;
    float dir_signal = atan2f(dir_signal_v.x, dir_signal_v.y)*57.2957795f;

    float dir = fmodf(dir_antenna + dir_signal, 360.0f);
    float elev = elev_antenna + elev_signal;

    if (elev > 90.0f || elev < -90.0f) {
        dir = fmodf(dir + 180.0f, 360.0f);
        if (elev < -90.0f) {
            elev = -90.0f + (std::fabs(elev) - 90.0f);
        }
        else {
            elev = 90.0f - (elev - 90.0f);
        }
    }

    if (dir < 0.0f) {
        dir = dir + 360.0f;
    }

    elev = 90.0f - std::fabs(elev);

    float lower_freq_gain = _get_gain(f_, dir, elev);
    float upper_freq_gain = _get_gain(f_ + _frequency_step, dir, elev);

    float lower_freq = f_ - fmodf(f_, _frequency_step);
    float upper_freq = lower_freq + _frequency_step;

    float total_gain = _interp(f_, lower_freq, upper_freq, lower_freq_gain, upper_freq_gain);


    return total_gain;
}

float acre::signal::antenna::_get_gain(float f_, float dir_, float elev_)
{
    uint32_t f_index = (uint32_t)std::floor((f_ - _min_frequency)/_frequency_step);
    if (f_index > _total_entries - 1)
        f_index = _total_entries - 1;
    uint32_t dir_index_min = (uint32_t)std::floor(dir_ / _direction_step);
    uint32_t dir_index_max = (uint32_t)std::floor((dir_ + _direction_step) / _direction_step);

    uint32_t elev_index_min = (uint32_t)std::floor(elev_ / _elevation_step);
    uint32_t elev_index_max = (uint32_t)std::floor((elev_ + _elevation_step) / _elevation_step);
    if (dir_index_max > _height - 1) {
        dir_index_max = 0;
    }

    if (elev_index_max > _width - 1) {
        elev_index_max = _width - 1;
    }

    float gain_d_min_e_min = _gain_map[f_index * (_width * _height) + (dir_index_min * _width) + elev_index_min].v;
    float gain_d_min_e_max = _gain_map[f_index * (_width * _height) + (dir_index_min * _width) + elev_index_max].v;

    float gain_d_max_e_min = _gain_map[f_index * (_width * _height) + (dir_index_max * _width) + elev_index_min].v;
    float gain_d_max_e_max = _gain_map[f_index * (_width * _height) + (dir_index_max * _width) + elev_index_max].v;

    float dir_min = dir_ - fmodf(dir_, _direction_step);
    float dir_max = dir_min + _direction_step;

    float elev_min = elev_ - fmodf(elev_, _elevation_step);
    float elev_max = elev_min + _elevation_step;

    float elev_lower_gain = _interp(dir_, dir_min, dir_max, gain_d_min_e_min, gain_d_max_e_min);
    float elev_upper_gain = _interp(dir_, dir_min, dir_max, gain_d_min_e_max, gain_d_max_e_max);

    float total_gain = _interp(elev_, elev_min, elev_max, elev_lower_gain, elev_upper_gain);

    return total_gain;
}

float acre::signal::antenna::_interp(float g_, float g1_, float g2_, float d1_, float d2_) {
    return d1_ + (std::max((g_ - g1_), 0.00001f) / std::max((g2_ - g1_), 0.00001f))*(d2_ - d1_);
}
