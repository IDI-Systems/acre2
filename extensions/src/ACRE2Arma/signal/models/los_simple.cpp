#include "los_simple.hpp"
#include "glm\geometric.hpp"
#include "glm\gtx\vector_angle.hpp"

acre::signal::model::los_simple::los_simple(map_p map_) : _map(map_)
{

}

acre::signal::model::los_simple::~los_simple()
{

}

void acre::signal::model::los_simple::process(result *result_, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const glm::vec3 &rx_pos_, const glm::vec3 &rx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, float frequency_, float power_, float scale_, bool omnidirectional_)
{
    float rx_gain, tx_gain, distance_3d;

    distance_3d = glm::distance(tx_pos_, rx_pos_);

    rx_gain = 0.0f;//rx_antenna_.gain(rx_pos_, tx_pos_);
    tx_gain = 0.0f;//tx_antenna_.gain(tx_pos_, rx_pos_);

    float tx_power = 10.0f * (log10(power_ / 1000.0f)) + 30.0f;

    float fspl = -27.55f + 20.0f * log10(frequency_) + 20.0f * log10(distance_3d);

    //_Lb = _Ptx + _transmitterGain - _Ltx - _Lfs - _Lm + _receiverGain - _Lrx;
    float tx_internal_loss = 3;
    float rx_internal_loss = 3;

    float diffraction_loss = _diffraction_loss(tx_pos_, rx_pos_, frequency_);

    float budget = tx_power + tx_gain - tx_internal_loss - fspl - diffraction_loss + rx_gain - rx_internal_loss;
    result_->result_v = _dbm_to_v(budget, 50.0f);
    result_->result_dbm = budget;
    //printf("budget: %fdBm", budget);

}

float acre::signal::model::los_simple::_diffraction_loss(glm::vec3 pos1_, glm::vec3 pos2_, float frequency_)
{
    float sample_size = 7.5f;
    std::vector<float> terrain_profile;
    _map->terrain_profile(pos1_, pos2_, sample_size, terrain_profile);

    glm::vec3 dir = glm::normalize(pos2_ - pos1_)*sample_size;

    float total_distance_2d = glm::distance(glm::vec2(pos1_.x, pos1_.y), glm::vec2(pos2_.x, pos2_.y));
    if (terrain_profile.size() < 4) {
        return 0.0f;
    }
    float loss = 0.0f;
    for (int c = 0; c < (int)terrain_profile.size() - 1; ++c) {
        float sample = terrain_profile[c];
        float last_sample = terrain_profile[std::max(c - 1, 0)];
        float next_sample = terrain_profile[std::min((int)terrain_profile.size(), c + 1)];
        if (last_sample < sample && next_sample < sample) {
            glm::vec3 peak_ray_pos = pos1_ + dir*(float)c;

            float d1 = glm::distance(glm::vec2(pos1_.x, pos1_.y), glm::vec2(peak_ray_pos.x, peak_ray_pos.y));
            float d2 = total_distance_2d - d1;
            loss += _itu(peak_ray_pos.z - sample, d1 / 1000.0f, d2 / 1000.0f, frequency_ / 1000.0f);
        }
    }

    return loss;
}

float acre::signal::model::los_simple::_itu(float h, float d1_km_, float d2_km_, float f_ghz_)
{
    float d = d1_km_ + d2_km_;

    float F1 = 17.3f * sqrt((d1_km_ * d2_km_) / (f_ghz_ * d));

    float A = -20.0f * h / F1 + 10.0f;

    if (A < 6.0f) return 0.0f;

    return A;
}

acre::signal::model::multipath::multipath(map_p map_) : los_simple(map_)
{
    uint32_t peak_grid_size = (uint32_t)std::ceil(_map->map_size()*_map->cell_size()/1000.0f);
    _peak_buckets.resize((size_t)std::pow(peak_grid_size, (uint32_t)2));
    for (auto peak : _map->peaks) {
        int x = (int)std::floor(peak.x / 1000);
        int y = (int)std::floor(peak.y / 1000);
        _peak_buckets[x * peak_grid_size + y].push_back(peak);
    }
}

acre::signal::model::multipath::~multipath()
{

}
#define MAGIC 10.0f
float acre::signal::model::multipath::_search_distance(float frequency_, float power_) {
    auto cache = _distance_cache.find(std::floor(frequency_));
    if (cache != _distance_cache.end()) {
        if (cache->second.find(std::floor(power_)) != cache->second.end()) {
            return cache->second.find(std::floor(power_))->second;
        }
    }
    float test_fspl = 0;
    int c = 0;
    float search_distance = 0.0f;
    float tx_power = 10.0f * log10(power_ / 1000.0f) + 30.0f;
    while (test_fspl < 80.0f + tx_power) {
        search_distance = (c*250.0f);
        test_fspl = (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(search_distance)) + (MAGIC*3.0f);
        c++;
    }
    
    if (cache == _distance_cache.end()) {
        _distance_cache[std::floor(frequency_)] = std::map<float, float>();
        cache = _distance_cache.find(std::floor(frequency_));
    }
    cache->second[std::floor(power_)] = search_distance;
    return search_distance;
}

void acre::signal::model::multipath::process(result *result_, const glm::vec3 &tx_pos_, const glm::vec3 &tx_dir_, const glm::vec3 &rx_pos_, const glm::vec3 &rx_dir_, const antenna_p &tx_antenna_, const antenna_p &rx_antenna_, float frequency_, float power_, float scale_, bool omnidirectional_)
{
    glm::vec2 tx_pos_2d, rx_pos_2d;
    tx_pos_2d = glm::vec2(tx_pos_.x, tx_pos_.y);
    rx_pos_2d = glm::vec2(rx_pos_.x, rx_pos_.y);

    float tx_power = 10.0f * log10(power_ / 1000.0f) + 30.0f;

    float distance_2d = glm::distance(tx_pos_2d, rx_pos_2d);
    float distance_3d = glm::distance(tx_pos_, rx_pos_);
    
    float search_distance = _search_distance(frequency_, power_);

    int search_size = (int)(search_distance * 2 / 1000.0f);//(int)(std::ceil(std::max(search_distance, distance_2d)) / 1000.0f);

    if (search_size % 2 == 0) {
        search_size++;
    }

    glm::vec2 center_pos = tx_pos_2d + glm::normalize(rx_pos_2d - tx_pos_2d)*(distance_2d*0.5f);
    //search_size = (int)std::ceil(_map->map_size()*_map->cell_size() / 1000.0f);

    if (tx_pos_.x != _cached_tx_pos.x || tx_pos_.y != _cached_tx_pos.y) {
        _get_peaks_spiral(tx_pos_.x, tx_pos_.y, search_size, search_size, _cached_peaks);
        _cached_tx_pos = tx_pos_;
    }
        

    std::vector<float> signals;
    std::vector<float> signal_phases;
    int good_count = 0;

    float best_signal = 0.0f;
    int best_signal_index = 0;

    for (auto peak : _cached_peaks) {
        glm::vec3 v_tx, v_rx, v_mid;
        v_tx = tx_pos_ - peak;
        v_rx = rx_pos_ - peak;
        if (glm::distance(glm::normalize(v_tx), glm::normalize(v_rx)) > 1.41421f)
            continue;

        v_mid = glm::normalize(v_tx + v_rx);

        glm::vec3 best_angle;
        float best_distance = 10000.0f;

        
        

        
        float diffraction_loss = 0;
        
        for (int i = 0; i <= 40; ++i) {
            glm::vec3 test_point = peak + v_mid*(float)i*(7.5f);
            glm::vec3 t_normal = _map->normal(test_point.x, test_point.y);
            float distance = glm::distance2(t_normal, v_mid);
            if (distance < best_distance) {
                best_distance = distance;
                best_angle = test_point;
            }
        }
        best_angle.z = _map->elevation(best_angle.x, best_angle.y);

        //float add_test_height = 20.0f * log10(frequency_) + 20.0f * log10(std::ceil(glm::distance(tx_pos_, best_angle)));
        //glm::vec3 test_pos = tx_pos_ + glm::vec3(0, 0, add_test_height);
        //if (!_map->ground_intersect(test_pos, glm::normalize(test_pos - best_angle), std::ceil(glm::distance(test_pos, best_angle)))) {
            float tx_internal_loss = 3.0f;
            float rx_internal_loss = 3.0f;


            float rx_gain = 0;
            if (!omnidirectional_) rx_gain = rx_antenna_->gain(rx_dir_, best_angle - rx_pos_, frequency_);
            float tx_gain = 0;
            if (!omnidirectional_) tx_gain = tx_antenna_->gain(tx_dir_, best_angle - tx_pos_, frequency_);

            float path_distance = sqrt(glm::distance2(tx_pos_, best_angle) + glm::distance2(rx_pos_, best_angle));
            float fspl = (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(path_distance));
            //float fspl = (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(glm::distance(tx_pos_, best_angle))) + 
            //    (-27.55f + 20.0f * log10(frequency_) + 20.0f * log10(glm::distance(rx_pos_, best_angle)));

            glm::vec3 best_angle_v = glm::normalize(rx_pos_ - best_angle);
            glm::vec3 terrain_normal = _map->normal(best_angle.x, best_angle.y);
            /*
            float baz = asin(terrain_normal.z);
            float bav = asin(glm::normalize(best_angle_v).z);
            float bt = baz - bav;
            float reflection_ratio = std::cos(bt);
            */
            float reflection_ratio = glm::dot(terrain_normal, glm::normalize(best_angle_v));

            float tx_power = 10.0f * log10((power_ * reflection_ratio) / 1000.0f) + 30.0f;

            float budget = tx_power + tx_gain - tx_internal_loss - fspl - ((-27.55f + 20.0f * log10(frequency_))) + rx_gain - rx_internal_loss;

            if (budget > -200.0f) {
                diffraction_loss = _diffraction_loss(tx_pos_, best_angle, frequency_)*scale_;
                if (budget - diffraction_loss > -200.0f) {
                    diffraction_loss += _diffraction_loss(best_angle, rx_pos_, frequency_)*scale_;
                    budget -= diffraction_loss;

                    
                    if (budget > -200.0f) {
                        float budget_v = _dbm_to_v(budget, 50.0f);
                        signals.push_back(budget_v);
                        float phase = _phase(path_distance, frequency_) + PI;
                        signal_phases.push_back(phase);
                        result_->reflect_points.push_back(reflection(best_angle, terrain_normal, phase, reflection_ratio, budget, budget_v));
                        if (budget_v > best_signal) {
                            best_signal = budget_v;
                            best_signal_index = signals.size()-1;
                        }
                        ++good_count;
                    }
                }
            }
        //}
        if (good_count >= 10)
            break;
    }
    float rx_gain = 0;
    if (!omnidirectional_) rx_gain = rx_antenna_->gain(rx_dir_, tx_pos_ - rx_pos_, frequency_);
    float tx_gain = 0;
    if (!omnidirectional_) tx_gain = tx_antenna_->gain(tx_dir_, rx_pos_ - tx_pos_, frequency_);
    

    float fspl = -27.55f + 20.0f * log10(frequency_) + 20.0f * log10(distance_3d);

    //_Lb = _Ptx + _transmitterGain - _Ltx - _Lfs - _Lm + _receiverGain - _Lrx;
    float tx_internal_loss = 3.0f;
    float rx_internal_loss = 3.0f;

    float diffraction_loss = _diffraction_loss(tx_pos_, rx_pos_, frequency_)*scale_;

    float budget = tx_power + tx_gain - tx_internal_loss - fspl - (MAGIC*1.0f) - diffraction_loss + rx_gain - rx_internal_loss;
    float budget_v = _dbm_to_v(budget, 50.0f);

    signals.push_back(budget_v);
    signal_phases.push_back(_phase(distance_3d, frequency_));

    if (budget_v > best_signal) {
        best_signal = budget_v;
        best_signal_index = signals.size() - 1;
    }

    float total_signal;

    if(scale_ >= 1.0f) {
        float best_signal_phase = signal_phases[best_signal_index];
        total_signal = best_signal;

        for (size_t c = 0; c <= signals.size() - 1; ++c) {
            if (c != best_signal_index) {
                float signal_level = signals[c];
                float phase = signal_phases[c] - best_signal_phase;
                if (phase > PI)
                    phase -= PI*2;
                else if (phase < -PI)
                    phase += PI*2;
                total_signal = _phase_amplitude(total_signal, signal_level, phase);
            }
        }
    }
    else {
        total_signal = best_signal;
    }
    if (total_signal > 0.0f) {
        result_->result_v = total_signal;
        result_->result_dbm = _v_to_dbm(total_signal, 50.0f);
    }
    else {
        result_->result_v = 0.0f;
        result_->result_dbm = -1000.0f;
    }
}

void acre::signal::model::multipath::_get_peaks_spiral(float pos_x_, float pos_y_, int x_, int y_, std::vector<glm::vec3> &peaks_) {
    int peak_grid_size = (int)std::ceil(_map->map_size()*_map->cell_size() / 1000.0f);
    int peak_grid_x, peak_grid_y;
    peak_grid_x = (int)std::floor(pos_x_ / 1000.0f);
    peak_grid_y = (int)std::floor(pos_y_ / 1000.0f);

    int x, y, dx, dy;
    x = y = dx = 0;
    dy = -1;
    int t = std::max(x_, y_);
    int max_i = t*t;
    for (int i = 0; i < max_i; i++) {
        if ((-x_ / 2 <= x) && (x <= x_ / 2) && (-y_ / 2 <= y) && (y <= y_ / 2)) {
            if (peak_grid_x + x >= 0 && peak_grid_x + x < peak_grid_size - 1 && peak_grid_y + y >= 0 && peak_grid_y + y < peak_grid_size - 1) {
                int peak_index = (peak_grid_x + x) * peak_grid_size + peak_grid_y + y;
                if(_peak_buckets[peak_index].size() > 0)
                    peaks_.insert(peaks_.end(), 
                        _peak_buckets[peak_index].begin(),
                        _peak_buckets[peak_index].end());
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
