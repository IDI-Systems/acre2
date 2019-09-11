#include "los_simple.hpp"

#include <glm/geometric.hpp>
#include <glm/gtx/vector_angle.hpp>

#include <cmath>

static const float32_t PI = 3.14159265f;
static const float32_t magic = 10.0f;

acre::signal::model::los_simple::los_simple(map_p map_) : SignalModel() {
    _map = map_;
}

acre::signal::model::los_simple::~los_simple() {

}

void acre::signal::model::los_simple::process(result *const result, const glm::vec3 &tx_pos, const glm::vec3 &tx_dir, const glm::vec3 &rx_pos, const glm::vec3 &rx_dir, const antenna_p &tx_antenna, const antenna_p &rx_antenna, const float32_t frequency, const float32_t power, const float32_t scale, const bool omnidirectional) {
    const float32_t distance_3d = glm::distance(tx_pos, rx_pos);

    const float32_t tx_power = 10.0f * (log10f(power / 1000.0f)) + 30.0f;
    const float32_t fspl = -27.55f + 20.0f * log10f(frequency) + 20.0f * log10f(distance_3d);

    float32_t rx_gain = 0.0f;
    float32_t tx_gain = 0.0f;
    if (!omnidirectional) {
        rx_gain = rx_antenna->gain(rx_dir, tx_pos - rx_pos, frequency);
        tx_gain = tx_antenna->gain(tx_dir, rx_pos - tx_pos, frequency);
    }

    //_Lb = _Ptx + _transmitterGain - _Ltx - _Lfs - _Lm + _receiverGain - _Lrx;
    const float32_t tx_internal_loss = tx_antenna->getInternalLoss_dBm();
    const float32_t rx_internal_loss = rx_antenna->getInternalLoss_dBm();

    const float32_t diffractionLoss = diffraction_loss(tx_pos, rx_pos, frequency)*scale;

    const float32_t budget = tx_power + tx_gain - tx_internal_loss - fspl - diffractionLoss + rx_gain - rx_internal_loss;
    result->result_v = dbm_to_v(budget, 50.0f);
    result->result_dbm = budget;
}

float32_t acre::signal::model::los_simple::diffraction_loss(const glm::vec3 &pos1, const glm::vec3 &pos2, const float32_t frequency) {
    const float32_t sample_size = 7.5f;
    std::vector<float32_t> terrain_profile;
    _map->terrain_profile(pos1, pos2, sample_size, terrain_profile);

    const glm::vec3 dir = glm::normalize(pos2 - pos1)*sample_size;

    const float32_t total_distance_2d = glm::distance(glm::vec2(pos1.x, pos1.y), glm::vec2(pos2.x, pos2.y));
    if (terrain_profile.size() < 4) {
        return 0.0f;
    }
    float32_t loss = 0.0f;
    for (int32_t c = 0; c < (int32_t) terrain_profile.size() - 1; ++c) {
        float32_t sample = terrain_profile[c];
        float32_t last_sample = terrain_profile[std::max(c - 1, 0)];
        float32_t next_sample = terrain_profile[std::min((int32_t)terrain_profile.size(), c + 1)];
        if ((last_sample < sample) && (next_sample < sample)) {
            const glm::vec3 peak_ray_pos = pos1 + dir*static_cast<float32_t>(c);

            const float32_t d1 = glm::distance(glm::vec2(pos1.x, pos1.y), glm::vec2(peak_ray_pos.x, peak_ray_pos.y));
            const float32_t d2 = total_distance_2d - d1;
            loss += itu(peak_ray_pos.z - sample, d1 / 1000.0f, d2 / 1000.0f, frequency / 1000.0f);
        }
    }

    return loss;
}

float32_t acre::signal::model::los_simple::itu(const float32_t h, const float32_t d1_km, float32_t d2_km, float32_t f_GHz) {
    const float32_t d = d1_km + d2_km;
    const float32_t F1 = 17.3f * sqrtf((d1_km * d2_km) / (f_GHz * d));
    const float32_t A = -20.0f * h / F1 + 10.0f;

    if (A < 6.0f) {
        return 0.0f;
    }

    return A;
}

acre::signal::model::multipath::multipath(map_p map_) : los_simple(map_) {
    const uint32_t peak_grid_size = static_cast<uint32_t>(ceilf(_map->map_size()*_map->cell_size()/1000.0f));
    _peak_buckets.resize(static_cast<size_t>(std::pow(peak_grid_size, 2u)));
    for (auto peak : _map->peaks) {
        const int32_t x = static_cast<int32_t>(floorf(peak.x / 1000));
        const int32_t y = static_cast<int32_t>(floorf(peak.y / 1000));
        _peak_buckets[x * peak_grid_size + y].push_back(peak);
    }
}

acre::signal::model::multipath::~multipath() {

}

float32_t acre::signal::model::multipath::search_distance(const float32_t frequency_Hz, const float32_t power_mW) {
    auto cache = _distance_cache.find(floorf(frequency_Hz));
    if (cache != _distance_cache.end()) {
        if (cache->second.find(floorf(power_mW)) != cache->second.end()) {
            return cache->second.find(floorf(power_mW))->second;
        }
    }
    float32_t test_fspl = 0;
    int32_t c = 0;
    float32_t searchDistance = 0.0f;
    const float32_t tx_power = 10.0f * log10f(power_mW / 1000.0f) + 30.0f;
    while (test_fspl < (80.0f + tx_power)) {
        searchDistance = static_cast<float32_t>(c)*250.0f;
        test_fspl = (-27.55f + 20.0f * log10f(frequency_Hz) + 20.0f * log10f(searchDistance)) + (magic*3.0f);
        c++;
    }

    if (cache == _distance_cache.end()) {
        _distance_cache[floorf(frequency_Hz)] = std::map<float32_t, float32_t>();
        cache = _distance_cache.find(floorf(frequency_Hz));
    }
    cache->second[floorf(power_mW)] = searchDistance;
    return searchDistance;
}

void acre::signal::model::multipath::process(result *const result_, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const glm::vec3 &rx_pos_, const glm::vec3 &rx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, const float32_t frequency_, const float32_t power_, const float32_t scale_, const bool omnidirectional_) {
    const float32_t tx_power = 10.0f * log10f(power_ / 1000.0f) + 30.0f;
    const float32_t distance_3d = glm::distance(tx_pos_, rx_pos_);
    const float32_t searchDistance = search_distance(frequency_, power_);

    int32_t search_size = static_cast<int32_t>(searchDistance * 2.0f / 1000.0f);//(int)(std::ceil(std::max(search_distance, distance_2d)) / 1000.0f);

    if (search_size % 2 == 0) {
        search_size++;
    }

    if ((tx_pos_.x != _cached_tx_pos.x) || (tx_pos_.y != _cached_tx_pos.y)) {
        get_peaks_spiral(tx_pos_.x, tx_pos_.y, search_size, search_size, _cached_peaks);
        _cached_tx_pos = tx_pos_;
    }

    std::vector<float32_t> signals;
    std::vector<float32_t> signal_phases;
    int32_t good_count = 0;

    float32_t best_signal = 0.0f;
    size_t best_signal_index = 0;

    const float32_t tx_internal_loss = tx_antenna_->getInternalLoss_dBm();
    const float32_t rx_internal_loss = rx_antenna_->getInternalLoss_dBm();

    for (auto peak : _cached_peaks) {
        const glm::vec3 v_tx = tx_pos_ - peak;
        const glm::vec3 v_rx = rx_pos_ - peak;
        if (glm::distance(glm::normalize(v_tx), glm::normalize(v_rx)) > 1.41421f) {
            continue;
        }

        const glm::vec3 v_mid = glm::normalize(v_tx + v_rx);

        glm::vec3 best_angle;
        float32_t best_distance = 10000.0f;
        float32_t diffractionLoss = 0.0f;

        for (int32_t i = 0; i <= 40; ++i) {
            glm::vec3 test_point = peak + v_mid*static_cast<float32_t>(i)*7.5f;
            glm::vec3 t_normal = _map->normal(test_point.x, test_point.y);
            const float32_t distance = glm::distance2(t_normal, v_mid);
            if (distance < best_distance) {
                best_distance = distance;
                best_angle = test_point;
            }
        }

        best_angle.z = _map->elevation(best_angle.x, best_angle.y);

        //float32_t add_test_height = 20.0f * log10(frequency_) + 20.0f * log10(std::ceil(glm::distance(tx_pos_, best_angle)));
        //glm::vec3 test_pos = tx_pos_ + glm::vec3(0, 0, add_test_height);
        //if (!_map->ground_intersect(test_pos, glm::normalize(test_pos - best_angle), std::ceil(glm::distance(test_pos, best_angle)))) {

        float32_t rx_gain = 0;
        float32_t tx_gain = 0;
        if (!omnidirectional_){
            rx_gain = rx_antenna_->gain(rx_dir_, best_angle - rx_pos_, frequency_);
            tx_gain = tx_antenna_->gain(tx_dir_, best_angle - tx_pos_, frequency_);
        }

        float32_t path_distance = sqrtf(glm::distance2(tx_pos_, best_angle) + glm::distance2(rx_pos_, best_angle));
        float32_t fspl = (-27.55f + 20.0f * log10f(frequency_) + 20.0f * log10f(path_distance));
        //float32_t fspl = (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(glm::distance(tx_pos_, best_angle))) +
        //    (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(glm::distance(rx_pos_, best_angle)));

        const glm::vec3 best_angle_v = glm::normalize(rx_pos_ - best_angle);
        const glm::vec3 terrain_normal = _map->normal(best_angle.x, best_angle.y);
        /*
            float32_t baz = asin(terrain_normal.z);
            float32_t bav = asin(glm::normalize(best_angle_v).z);
            float32_t bt = baz - bav;
            float32_t reflection_ratio = std::cos(bt);
         */
        const float32_t reflection_ratio = glm::dot(terrain_normal, glm::normalize(best_angle_v));
        const float32_t tx_power = 10.0f * log10f((power_ * reflection_ratio) / 1000.0f) + 30.0f;
        float32_t budget = tx_power + tx_gain - tx_internal_loss - fspl - ((-27.55f + 20.0f * log10f(frequency_))) + rx_gain - rx_internal_loss;

        if (budget > -200.0f) {
            diffractionLoss = diffraction_loss(tx_pos_, best_angle, frequency_)*scale_;
            if (budget - diffractionLoss > -200.0f) {
                diffractionLoss += diffraction_loss(best_angle, rx_pos_, frequency_)*scale_;
                budget -= diffractionLoss;

                if (budget > -200.0f) {
                    const float32_t budget_v = dbm_to_v(budget, 50.0f);
                    signals.push_back(budget_v);

                    const float32_t signalPhase = phase(path_distance, frequency_) + PI;
                    signal_phases.push_back(signalPhase);
                    result_->reflect_points.push_back(reflection(best_angle, terrain_normal, signalPhase, reflection_ratio, budget, budget_v));
                    if (budget_v > best_signal) {
                        best_signal = budget_v;
                        best_signal_index = signals.size() - 1u;
                    }
                    ++good_count;
                }
            }
        }

        if (good_count >= 10){
            break;
        }
    }
    float32_t rx_gain = 0.0f;
    float32_t tx_gain = 0.0f;
    if (!omnidirectional_) {
        rx_gain = rx_antenna_->gain(rx_dir_, tx_pos_ - rx_pos_, frequency_);
        tx_gain = tx_antenna_->gain(tx_dir_, rx_pos_ - tx_pos_, frequency_);
    }

    fspl = -27.55f + 20.0f * log10f(frequency_) + 20.0f * log10f(distance_3d);

    //_Lb = _Ptx + _transmitterGain - _Ltx - _Lfs - _Lm + _receiverGain - _Lrx;

    const float32_t diffractionLoss = diffraction_loss(tx_pos_, rx_pos_, frequency_)*scale_;

    const float32_t budget = tx_power + tx_gain - tx_internal_loss - fspl - (magic*1.0f) - diffractionLoss + rx_gain - rx_internal_loss;
    const float32_t budget_v = dbm_to_v(budget, 50.0f);

    signals.push_back(budget_v);
    signal_phases.push_back(phase(distance_3d, frequency_));

    if (budget_v > best_signal) {
        best_signal = budget_v;
        best_signal_index = signals.size() - 1u;
    }

    float32_t total_signal = 0.0f;

    if (scale_ >= 1.0f) {
        float32_t best_signal_phase = signal_phases[best_signal_index];
        total_signal = best_signal;

        for (size_t c = 0; c <= signals.size() - 1; ++c) {
            if (c != best_signal_index) {
                const float32_t signal_level = signals[c];
                float32_t singalPhase = signal_phases[c] - best_signal_phase;
                if (singalPhase > PI) {
                    singalPhase -= PI*2.0f;
                } else if (singalPhase < -PI) {
                    singalPhase += PI*2.0f;
                }
                total_signal = phase_amplitude(total_signal, signal_level, singalPhase);
            }
        }
    } else {
        total_signal = best_signal;
    }

    if (total_signal > 0.0f) {
        result_->result_v = total_signal;
        result_->result_dbm = v_to_dbm(total_signal, 50.0f);
    } else {
        result_->result_v = 0.0f;
        result_->result_dbm = -1000.0f;
    }
}

void acre::signal::model::multipath::get_peaks_spiral(const float32_t pos_x, const float32_t pos_y, const int32_t size_x, const int32_t size_y, std::vector<glm::vec3> &peaks) {
    const int32_t peak_grid_size = static_cast<int32_t>(ceilf(_map->map_size()*_map->cell_size() / 1000.0f));
    const int32_t peak_grid_x = static_cast<int32_t>(floorf(pos_x / 1000.0f));
    const int32_t peak_grid_y = static_cast<int32_t>(floorf(pos_y / 1000.0f));

    int32_t x = 0;
    int32_t y = 0;
    int32_t dx = 0;
    int32_t dy = -1;

    int32_t t = std::max(size_x, size_y);
    const int32_t max_i = t*t;
    for (int32_t i = 0; i < max_i; i++) {
        if ((-size_x / 2 <= x) && (x <= size_x / 2) && (-size_y / 2 <= y) && (y <= size_y / 2)) {
            if (((peak_grid_x + x) >= 0)
                    && ((peak_grid_x + x) < (peak_grid_size - 1))
                    && ((peak_grid_y + y) >= 0)
                    && ((peak_grid_y + y) < (peak_grid_size - 1))) {
                const int32_t peak_index = (peak_grid_x + x) * peak_grid_size + peak_grid_y + y;
                if (_peak_buckets[peak_index].size() > 0) {
                    peaks.insert(peaks.end(), _peak_buckets[peak_index].begin(), _peak_buckets[peak_index].end());
                }
            }
        }
        if ((x == y) || ((x < 0) && (x == -y)) || ((x > 0) && (x == 1 - y))) {
            t = dx;
            dx = -dy;
            dy = t;
        }
        x += dx;
        y += dy;
    }
}

float32_t acre::signal::model::multipath::phase(const float32_t path_distance, const float32_t f_Mhz) {
    const float32_t phase = PI*2.0f*path_distance / (300.0f / f_Mhz);
    return fmod(phase, PI * 2.0f) - PI;
}

float32_t acre::signal::model::multipath::phase_amplitude(const float32_t a1, const float32_t a2, const float32_t phase) {
    return sqrtf(powf(a1, 2.0f) + powf(a2, 2.0f) + 2.0f*a1*a2*cosf(phase));
}
