#include "map.hpp"

#include <fstream>
#include <iostream>
#include <sstream>
#include <regex>
#include <algorithm>

#include <glm/geometric.hpp>
#include <glm/gtx/intersect.hpp>
#include <glm/gtx/normal.hpp>

acre::signal::map::map(const std::string xyz_path_, const uint32_t map_size_, const float32_t cell_size_, acre_mapClimate_t mapClimate_)
: _mapClimate(mapClimate_) {
    this->_map_elevations = new float32_t[_map_size * _map_size];
    this->_inv_cell_size = 1.0f / _cell_size;

    std::string line;
    std::ifstream xyz_file(xyz_path_);
    uint32_t elevation_index = 0;

    if (xyz_file.is_open()) {
        while (std::getline(xyz_file, line)) {
            size_t idx = 0;
            const float32_t x = std::stof(line, &idx);
            size_t y_off = idx;
            const float32_t y = std::stof(line.substr(y_off), &idx);
            size_t z_off = y_off + idx;
            const float32_t z = std::stof(line.substr(z_off));
            this->_map_elevations[elevation_index] = z;
            printf("%f\t\t%f\t\t%f\n", x, y, z);
            ++elevation_index;
        }
        xyz_file.close();
    }
    _generate_peaks();
}

acre::signal::map::map(const std::string bin_path_) : _mapClimate(acre_mapClimate_continentalTemperate) {
    std::ifstream bin_file(bin_path_, std::ifstream::binary);

    if (!bin_file.is_open()){
        return;
    }

    bin_file.read((char *) &_map_size, sizeof(uint32_t));
    bin_file.read((char *) &_cell_size, sizeof(float32_t));
    this->_map_elevations = new float[_map_size * _map_size];
    bin_file.read((char *) _map_elevations, _map_size * _map_size * sizeof(float32_t));
    _inv_cell_size = 1 / _cell_size;

    size_t peak_size = 0;
    bin_file.read((char *) &peak_size, sizeof(size_t));

    for (size_t i = 1; i <= peak_size; ++i) {
        float32_t x, y, z;
        bin_file.read((char *) &x, sizeof(float32_t));
        bin_file.read((char *) &y, sizeof(float32_t));
        bin_file.read((char *) &z, sizeof(float32_t));
        peaks.push_back(glm::vec3(x, y, z));
    }

    bin_file.close();
}

void acre::signal::map::load_asc_header(const std::string &ascHeaderPath) {
    std::ifstream asc_file(ascHeaderPath);
    if (!asc_file.is_open()) {
        return;
    }

    std::string line;
    std::smatch matches;
    std::regex exp("(\\w+?)\\s+([^\\s].+)");
    while (std::getline(asc_file, line) && std::regex_match(line.cbegin(), line.cend(), matches, exp)) {
        std::cout << matches[1] << ": " << matches[2] << "\n";
        asc_header[matches[1].str()] = std::stod(matches[2].str().c_str());
    }

    asc_file.close();
}

acre::signal::map::map(const std::string asc_path_, const bool use_degrees_) {
    this->_map_elevations = nullptr;
    std::ifstream asc_file(asc_path_);

    if (asc_file.is_open()) {
        std::string line;
        std::smatch matches;
        std::regex exp("(\\w+?)\\s+([^\\s].+)");
        while (std::getline(asc_file, line) && std::regex_match(line.cbegin(), line.cend(), matches, exp)) {
            std::cout << matches[1] << ": " << matches[2] << "\n";
            asc_header[matches[1].str()] = std::stod(matches[2].str().c_str());
        }

        std::vector<std::string> row_data;
        do {
            row_data.push_back(line);
        } while (std::getline(asc_file, line));

        bool pad_cols = false;
        int32_t pad_length = 0;
        if (asc_header["ncols"] < asc_header["nrows"]) {
            pad_cols = true;
            pad_length = static_cast<int32_t>(asc_header["nrows"] - asc_header["ncols"]);
            this->_map_size = static_cast<uint32_t>(asc_header["nrows"]);
        } else {
            this->_map_size = static_cast<uint32_t>(asc_header["ncols"]);
        }

        this->_mapClimate = acre_mapClimate_continentalTemperate;
        this->_cell_size = 10.0f;
        this->_inv_cell_size = 1.0f / _cell_size;
        this->_map_elevations = new float32_t[this->_map_size * this->_map_size];
        uint32_t elevation_index = 0;

        for (auto it = row_data.rbegin(); it != row_data.rend(); ++it) {
            std::string row_string = *it;
            std::stringstream ss(row_string);
            std::string item;
            const char delim = ' ';
            while (std::getline(ss, item, delim)) {
                float32_t elev = std::stof(item.c_str());
                if (elev == asc_header["nodata_value"]){
                    elev = 0.0f;
                }
                _map_elevations[elevation_index] = elev;
                ++elevation_index;
            }
            if (pad_cols) {
                for (int32_t i = 0; i < pad_length; ++i) {
                    _map_elevations[elevation_index] = 0.0f;
                    ++elevation_index;
                }
            }
        }
        if (asc_header["ncols"] > asc_header["nrows"]) {
            for (int32_t y = 0; y < asc_header["nrows"] - asc_header["ncols"]; ++y) {
                for (int32_t x = 0; x < asc_header["ncols"]; ++x) {
                    _map_elevations[elevation_index] = 0.0f;
                    ++elevation_index;
                }
            }
        }
        std::cout << "Size: " << elevation_index << "\n";
    }

    asc_file.close();

    _generate_peaks();
}
acre::signal::map::map(const acre::wrp::landscape_p wrp_) {
    this->_mapClimate = acre_mapClimate_continentalTemperate;
    this->_map_size = wrp_->map_size_x;
    this->_cell_size = wrp_->map_grid_size;
    this->_inv_cell_size = 1 / this->_cell_size;

    std::vector<glm::vec3> initial_peaks;
    for (auto wrp_peak : wrp_->peaks) {
        initial_peaks.push_back(glm::vec3(wrp_peak.x(), wrp_peak.z(), wrp_peak.y()));
    }

    for (uint32_t i = 0u; i < initial_peaks.size(); ++i) {
        auto test_peak = initial_peaks[i];
        if (test_peak.z > 5.0f) {
            bool ok = true;
            for (uint32_t c = 0; c < initial_peaks.size(); ++c) {
                auto test_peak2 = initial_peaks[c];

                if ((c != i) && (glm::distance(test_peak, test_peak2) <= 150.0f) && (test_peak2.z >= test_peak.z)) {
                    ok = false;
                    break;
                }
            }
            if (ok) {
                peaks.push_back(test_peak);
            }
        }
    }

    _map_elevations = new float[_map_size * _map_size];
    std::copy(wrp_->elevations.data.begin(),
            wrp_->elevations.data.end(),
            stdext::checked_array_iterator<float32_t *>(_map_elevations, _map_size * _map_size));

    if (strcmp(wrp_->filetype, "8WVR") == 0) {
        _generate_peaks(); // These WRP formats do not contain the peaks.
    }

}

acre::signal::map::~map() {
    if (this->_map_elevations) {
        delete[] this->_map_elevations;
        this->_map_elevations = nullptr;
    }
}

float32_t acre::signal::map::elevation(const float32_t x_, const float32_t y_, float32_t *const rd_x_, float32_t *const rd_y_) {
    const float32_t x_rel = x_ * _inv_cell_size;
    const float32_t y_rel = y_ * _inv_cell_size;
    const int32_t xi = static_cast<int32_t>(floorf(x_rel));
    const int32_t yi = static_cast<int32_t>(floorf(y_rel));
    const float32_t x_in = x_rel - xi;
    const float32_t y_in = y_rel - yi;

    const float32_t z00 = _internal_elevation(xi, yi);
    const float32_t z10 = _internal_elevation(xi + 1, yi);
    const float32_t z01 = _internal_elevation(xi, yi + 1);
    const float32_t z11 = _internal_elevation(xi + 1, yi + 1);

    if (x_in <= 1 - y_in) {
        const float32_t d1000 = z10 - z00;
        const float32_t d0100 = z01 - z00;
        if (rd_x_) {
            *rd_x_ = d1000 * _inv_cell_size;
            *rd_y_ = d0100 * _inv_cell_size;
        }
        return z00 + d0100 * y_in + d1000 * x_in;
    } else {
        // triangle 01,10,11
        const float32_t d1011 = z10 - z11;
        const float32_t d0111 = z01 - z11;
        if (rd_x_) {
            *rd_x_ = d0111 * -_inv_cell_size;
            *rd_y_ = d1011 * -_inv_cell_size;
        }
        return z10 + d0111 - d0111 * x_in - d1011 * y_in;
    }
}

float32_t acre::signal::map::elevation(const float32_t x_, const float32_t y_) {
    return elevation(x_, y_, nullptr, nullptr);
}

glm::vec3 acre::signal::map::normal(const float32_t x_, const float32_t y_) {
    float32_t d_x = 0.0f;
    float32_t d_y = 0.0f;

    elevation(x_, y_, &d_x, &d_y);
    glm::vec3 normal(-d_x, -d_y, 1.0);
    normal = glm::normalize(normal);

    return normal;
}

bool acre::signal::map::ground_intersect(const glm::vec3 &origin_, const glm::vec3 dir_, const float32_t max_distance_) {
    return ground_intersect(origin_, dir_, max_distance_, glm::vec3());
}

bool acre::signal::map::ground_intersect(const glm::vec3 &origin_, const glm::vec3 dir_, const float32_t max_distance_, glm::vec3 &result_) {
    const glm::vec3 end_pos = origin_ + dir_ * max_distance_;
    const std::vector<glm::vec2> grids = _grids_on_line(origin_.x, origin_.y, end_pos.x, end_pos.y);
    const glm::vec2 origin_2d = glm::vec2(origin_.x, origin_.y);
    const float32_t total_distance_2d = glm::distance(origin_2d, glm::vec2(end_pos.x, end_pos.y));

    for (auto grid_cell : grids) {
        const int32_t x = static_cast<int32_t>(floor((grid_cell.x * _inv_cell_size)));
        const int32_t y = static_cast<int32_t>(floor((grid_cell.y * _inv_cell_size)));

        const float32_t cell_max_height = this->_max_grid_height(x, y);
        const float32_t line_distance_3d = (glm::distance(origin_2d, grid_cell) / total_distance_2d) * max_distance_;
        const float32_t line_height = origin_.z + (dir_.z * line_distance_3d);
        if (line_height < cell_max_height) {
            glm::vec3 temp_result;
            const float32_t x_rel = grid_cell.x * _inv_cell_size;
            const float32_t y_rel = grid_cell.y * _inv_cell_size;
            const float32_t x_in = x_rel - x;
            const float32_t y_in = y_rel - y;

            const glm::vec3 v10((x + 1) * _cell_size, y * _cell_size, _internal_elevation(x + 1, y));
            const glm::vec3 v01(x * _cell_size, (y + 1) * _cell_size, _internal_elevation(x, y + 1));

            const glm::vec3 v00(x * _cell_size, y * _cell_size, _internal_elevation(x, y));
            if (glm::intersectLineTriangle(origin_, dir_, v00, v01, v10, temp_result)) {
                result_ = origin_ + dir_ * temp_result.x;
                return true;
            }

            const glm::vec3 v11((x + 1) * _cell_size, (y + 1) * _cell_size, _internal_elevation(x + 1, y + 1));
            if (glm::intersectLineTriangle(origin_, dir_, v11, v10, v01, temp_result)) {
                result_ = origin_ + dir_ * temp_result.x;
                return true;
            }
        }
    }
    return false;
}

void acre::signal::map::terrain_profile(const glm::vec3 &start_pos_, const glm::vec3 &end_pos_, const float32_t precision_, std::vector<float32_t> &profile_) {
    const glm::vec3 vector_to = glm::normalize(end_pos_ - start_pos_);

    const float32_t distance = glm::distance(start_pos_, end_pos_);
    const uint32_t steps = static_cast<uint32_t>(floorf(distance / precision_));

    for (uint32_t i = 0; i < steps; ++i) {
        const glm::vec3 sample_pos = vector_to * (i * precision_);
        profile_.push_back( this->elevation(sample_pos.x + start_pos_.x, sample_pos.y + start_pos_.y));
    }
}

void acre::signal::map::terrain_profile(const glm::vec3 &start_pos_, const glm::vec3 &end_pos_, const float32_t precision_, std::vector<float64_t> &profile_) {
    const glm::vec3 vector_to = glm::normalize(end_pos_ - start_pos_);

    const float32_t distance = glm::distance(start_pos_, end_pos_);
    const uint32_t steps = static_cast<uint32_t>(floorf(distance / precision_));

    for (uint32_t i = 0; i < steps; ++i) {
        const glm::vec3 sample_pos = vector_to * (i * precision_);
        profile_.push_back( static_cast<float64_t>(this->elevation(sample_pos.x + start_pos_.x, sample_pos.y + start_pos_.y)));
    }
}

void acre::signal::map::write_cache(const std::string &bin_path_) {
    const size_t peak_size = peaks.size();
    std::ofstream bin_file(bin_path_, std::ofstream::binary);

    bin_file.write((char *) &_map_size, sizeof(uint32_t));
    bin_file.write((char *) &_cell_size, sizeof(float32_t));
    bin_file.write((char *) _map_elevations, _map_size * _map_size * sizeof(float32_t));
    bin_file.write((char *) &peak_size, sizeof(size_t));
    for (auto peak : peaks) {
        const float32_t x = peak.x;
        const float32_t y = peak.y;
        const float32_t z = peak.z;
        bin_file.write((char *) &x, sizeof(float32_t));
        bin_file.write((char *) &y, sizeof(float32_t));
        bin_file.write((char *) &z, sizeof(float32_t));
    }

    bin_file.close();
}

void acre::signal::map::_generate_peaks() {
    std::vector<glm::vec2> first_pass_peaks;

    for (uint32_t x = 0u; x < _map_size; ++x) {
        for (uint32_t y = 0u; y < _map_size; ++y) {
            if (_is_peak(x, y)) {
                const float32_t z = _internal_elevation(x, y);
                if (z > 0.0f) {
                    first_pass_peaks.push_back(glm::vec2(x, y));
                }
            }
        }
    }

    const float32_t filter_distance = 150.0f;
    std::vector<glm::vec2> filtered_max_peaks;
    int32_t distance = static_cast<int32_t>(ceilf(filter_distance / _cell_size));

    for (auto peak : first_pass_peaks) {
        const int32_t peak_x = static_cast<int32_t>(peak.x);
        const int32_t peak_y = static_cast<int32_t>(peak.y);
        float32_t peak_height = _internal_elevation(peak_x, peak_y);

        const int32_t offset_x_min = std::max(peak_x - distance, 0);
        const int32_t offset_y_min = std::max(peak_y - distance, 0);

        const int32_t offset_x_max = std::min(peak_x + distance, static_cast<int32_t>(_map_size - 1u));
        const int32_t offset_y_max = std::min(peak_y + distance, static_cast<int32_t>(_map_size - 1u));
        bool is_max = true;
        float32_t average_height = 0;
        int32_t c = 0;
        for (int32_t x_pos = offset_x_min; x_pos <= offset_x_max; ++x_pos) {
            for (int32_t y_pos = offset_y_min; y_pos <= offset_y_max; ++y_pos) {
                const float32_t test_height = _internal_elevation(x_pos, y_pos);
                average_height += test_height;
                if ((test_height >= peak_height) && (x_pos != peak_x) && (y_pos != peak_y)) {
                    is_max = false;
                    break;
                }
                if (!is_max) {
                    break;
                }
                ++c;
            }
        }
        if (is_max) {
            average_height = average_height / c;
            if (average_height / peak_height > 0.5f) {
                bool not_found = true;
                for (auto filtered_peak : filtered_max_peaks) {
                    float32_t test_distance = sqrtf(powf(peak_x - filtered_peak.x, 2.0f) + powf(peak_y - filtered_peak.y, 2.0f));
                    if ((test_distance * _cell_size) < filter_distance) {
                        not_found = false;
                        break;
                    }
                }
                if (not_found) {
                    filtered_max_peaks.push_back(glm::vec2(peak_x, peak_y));
                }
            }
        }
    }

    for (auto filtered_peak : filtered_max_peaks) {
        const int32_t elev = _internal_elevation(static_cast<int32_t>(filtered_peak.x), static_cast<int32_t>(filtered_peak.y));
        peaks.push_back(glm::vec3(filtered_peak.x * _cell_size, filtered_peak.y * _cell_size, elev));
    }
}

inline float32_t acre::signal::map::_internal_elevation(const int32_t x_, const int32_t y_) {
    return _map_elevations[glm::max((glm::min(x_, static_cast<int32_t>(_map_size - 1u))), 0)
    + glm::max((glm::min(y_, static_cast<int32_t>(_map_size - 1u))), 0)
    * _map_size];
}

std::vector<glm::vec2> acre::signal::map::_grids_on_line(const float32_t x1_, const float32_t y1_, const float32_t x2_, const float32_t y2_) {
    const int32_t x1 = static_cast<int32_t>(floorf(x1_ / _cell_size));
    const int32_t y1 = static_cast<int32_t>(floorf(y1_ / _cell_size));
    const int32_t x2 = static_cast<int32_t>(floorf(x2_ / _cell_size));
    const int32_t y2 = static_cast<int32_t>(floorf(y2_ / _cell_size));

    int32_t ystep, xstep;    // the step on y and x axis
    int32_t error;           // the error accumulated during the increment
    int32_t errorprev;       // *vision the previous value of the error variable
    int32_t y = y1, x = x1;  // the line points
    int32_t ddy, ddx;        // compulsory variables: the double values of dy and dx
    int32_t dx = x2 - x1;
    int32_t dy = y2 - y1;

    std::vector<glm::vec2> points;

    points.push_back(glm::vec2(x1*_cell_size, y1*_cell_size)); // first point
    // NB the last point can't be here, because of its previous point (which has to be verified)
    if (dy < 0) {
        ystep = -1;
        dy = -dy;
    } else {
        ystep = 1;
    }

    if (dx < 0) {
        xstep = -1;
        dx = -dx;
    } else {
        xstep = 1;
    }

    ddy = 2 * dy;  // work with double values for full precision
    ddx = 2 * dx;
    if (ddx >= ddy) {  // first octant (0 <= slope <= 1)
        // compulsory initialization (even for errorprev, needed when dx==dy)
        errorprev = error = dx;  // start in the middle of the square
        for (int32_t i = 0; i < dx; i++) { // do not use the first point (already done)
            x += xstep;
            error += ddy;
            if (error > ddx) {  // increment y if AFTER the middle ( > )
                y += ystep;
                error -= ddx;
                // three cases (octant == right->right-top for directions below):
                if (error + errorprev < ddx){  // bottom square also
                    points.push_back(glm::vec2(x*_cell_size, (y - ystep)*_cell_size));
                } else if (error + errorprev > ddx) { // left square also
                    points.push_back(glm::vec2((x - xstep)*_cell_size, y*_cell_size));
                } else {  // corner: bottom and left squares also
                    points.push_back(glm::vec2(x*_cell_size, (y - ystep)*_cell_size));
                    points.push_back(glm::vec2((x - xstep)*_cell_size, y*_cell_size));
                }
            }
            points.push_back(glm::vec2(x*_cell_size, y*_cell_size));
            errorprev = error;
        }
    } else {  // the same as above
        errorprev = error = dy;
        for (int32_t i = 0; i < dy; i++) {
            y += ystep;
            error += ddx;
            if (error > ddy) {
                x += xstep;
                error -= ddy;
                if (error + errorprev < ddy){
                    points.push_back(glm::vec2((x - xstep)*_cell_size, y*_cell_size));
                } else if (error + errorprev > ddy) {
                    points.push_back(glm::vec2(x*_cell_size, (y - ystep)*_cell_size));
                } else {
                    points.push_back(glm::vec2((x - xstep)*_cell_size, y*_cell_size));
                    points.push_back(glm::vec2(x*_cell_size, (y - ystep)*_cell_size));
                }
            }
            points.push_back(glm::vec2(x*_cell_size, y*_cell_size));
            errorprev = error;
        }
    }
    // assert ((y == y2) && (x == x2));  // the last point (y2,x2) has to be the same with the last point of the algorithm

    return points;
}

float32_t acre::signal::map::_max_grid_height(const int32_t x_, const int32_t y_) {
    float32_t max_height = _internal_elevation(x_, y_);
    max_height = glm::max(max_height, _internal_elevation(x_ + 1, y_));
    max_height = glm::max(max_height, _internal_elevation(x_ + 1, y_ + 1));
    max_height = glm::max(max_height, _internal_elevation(x_, y_ + 1));

    return max_height;
}
bool acre::signal::map::_is_peak(const int32_t x_, const int32_t y_) {
    const float32_t height = _internal_elevation(x_, y_);
    int32_t p = 0;

    if (_internal_elevation(x_ - 1, y_ - 1) >= height) {
        p++;
    }
    if (_internal_elevation(x_ - 1, y_) >= height){
        p++;
    }
    if (_internal_elevation(x_ - 1, y_ + 1) >= height){
        p++;
    }
    if (_internal_elevation(x_ + 1, y_ - 1) >= height){
        p++;
    }
    if (_internal_elevation(x_ + 1, y_) >= height){
        p++;
    }
    if (_internal_elevation(x_ + 1, y_ + 1) >= height){
        p++;
    }
    if (_internal_elevation(x_, y_ - 1) >= height) {
        p++;
    }
    if (_internal_elevation(x_, y_ + 1) >= height){
        p++;
    }

    if (p == 8) {
        return false;
    } else if (p == 0) {
        return true;
    } else {
        return false;
    }
}

acre_mapClimate_t acre::signal::map::getMapClimate() {
    return this->_mapClimate;
}

void acre::signal::map::setMapClimate(const acre_mapClimate_t mapClimate) {
    this->_mapClimate = mapClimate;
}


