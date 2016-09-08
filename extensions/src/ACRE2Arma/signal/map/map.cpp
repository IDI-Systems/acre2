#include "map.hpp"
#include <fstream>
#include <iostream>
#include <sstream>
#include <regex>

#include "glm\geometric.hpp"
#include "glm\gtx\intersect.hpp"
#include "glm\gtx\normal.hpp"

#define POINT(y,x) points.push_back(glm::vec2((x)*_cell_size, (y)*_cell_size))

namespace acre {
    namespace signal {

        map::map(std::string xyz_path_, uint32_t map_size_, float cell_size_) : _map_size(map_size_), _cell_size(cell_size_)
        {
            this->_map_elevations = new float[_map_size*_map_size];
            _inv_cell_size = 1 / _cell_size;
            std::string line;
            std::ifstream xyz_file(xyz_path_);
            uint32_t elevation_index = 0;
            if (xyz_file.is_open()) {
                while (std::getline(xyz_file, line)) {
                    size_t idx = 0;
                    float x = std::stof(line, &idx);
                    size_t y_off = idx;
                    float y = std::stof(line.substr(y_off), &idx);
                    size_t z_off = y_off + idx;
                    float z = std::stof(line.substr(z_off));
                    this->_map_elevations[elevation_index] = z;
                    printf("%f\t\t%f\t\t%f\n", x, y, z);
                    ++elevation_index;
                }
                xyz_file.close();
            }
            _generate_peaks();
        }

        map::map(std::string bin_path_)
        {
            std::ifstream bin_file(bin_path_, std::ifstream::binary);
            if (bin_file.is_open()) {
                bin_file.read((char *)&_map_size, sizeof(uint32_t));
                bin_file.read((char *)&_cell_size, sizeof(float));
                this->_map_elevations = new float[_map_size*_map_size];
                bin_file.read((char *)_map_elevations, _map_size*_map_size*sizeof(float));
                _inv_cell_size = 1 / _cell_size;
                
                size_t peak_size = 0;
                bin_file.read((char *)&peak_size, sizeof(size_t));

                for (size_t i = 1; i <= peak_size; ++i) {
                    float x, y, z;
                    bin_file.read((char *)&x, sizeof(float));
                    bin_file.read((char *)&y, sizeof(float));
                    bin_file.read((char *)&z, sizeof(float));
                    peaks.push_back(glm::vec3(x, y, z));
                }
            }
            
            bin_file.close();
        }

        void map::load_asc_header(std::string asc_header_path_) {
            std::ifstream asc_file(asc_header_path_);
            if (asc_file.is_open()) {
                std::string line;
                std::smatch matches;
                std::regex exp("(\\w+?)\\s+([^\\s].+)");
                while (std::getline(asc_file, line) && std::regex_match(line.cbegin(), line.cend(), matches, exp)) {
                    std::cout << matches[1] << ": " << matches[2] << "\n";
                    asc_header[matches[1].str()] = std::stod(matches[2].str().c_str());
                }
            }
        }

        map::map(std::string asc_path_, bool use_degrees_) {
            this->_map_elevations = NULL;
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
                int pad_length = 0;
                if (asc_header["ncols"] < asc_header["nrows"]) {
                    pad_cols = true;
                    pad_length = (int)(asc_header["nrows"] - asc_header["ncols"]);
                    _map_size = (uint32_t)asc_header["nrows"];
                }
                else {
                    _map_size = (uint32_t)asc_header["ncols"];
                }
                _cell_size = 10;
                _inv_cell_size = 1 / _cell_size;
                this->_map_elevations = new float[_map_size*_map_size];
                uint32_t elevation_index = 0;
                std::vector<std::string>::reverse_iterator it = row_data.rbegin();
                for (it = row_data.rbegin(); it != row_data.rend(); ++it) {
                    std::string row_string = *it;
                    std::stringstream ss(row_string);
                    std::string item;
                    char delim = ' ';
                    while (std::getline(ss, item, delim)) {
                        float elev = std::stof(item.c_str());
                        //std::cout << elev << "\n";
                        if (elev == asc_header["nodata_value"])
                            elev = 0.0f;
                        _map_elevations[elevation_index] = elev;
                        ++elevation_index;
                    }
                    if (pad_cols) {
                        for (int i = 0; i < pad_length; ++i) {
                            _map_elevations[elevation_index] = 0.0f;
                            ++elevation_index;
                        }
                    }
                }
                if (asc_header["ncols"] > asc_header["nrows"]) {
                    for (int y = 0; y < asc_header["nrows"] - asc_header["ncols"]; ++y) {
                        for (int x = 0; x < asc_header["ncols"]; ++x) {
                            _map_elevations[elevation_index] = 0.0f;
                            ++elevation_index;
                        }
                    }
                }
                std::cout << "Size: " << elevation_index << "\n";
            }
            
            _generate_peaks();
        }
        map::map(acre::wrp::landscape_p wrp_)
        {
            _map_size = wrp_->map_size_x;
            _cell_size = wrp_->map_grid_size;
            _inv_cell_size = 1 / _cell_size;
            std::vector<glm::vec3> initial_peaks;
            for (auto wrp_peak : wrp_->peaks) {
                initial_peaks.push_back(glm::vec3(wrp_peak.x(), wrp_peak.z(), wrp_peak.y()));
            }

            //for (auto test_peak : initial_peaks) {
            for (uint32_t i = 0; i < initial_peaks.size(); ++i) {
                auto test_peak = initial_peaks[i];
                if (test_peak.z > 5.0f) {
                    bool ok = true;
                    for (uint32_t c = 0; c < initial_peaks.size(); ++c) {
                        auto test_peak2 = initial_peaks[c];

                        if (c != i && glm::distance(test_peak, test_peak2) <= 150.0f && test_peak2.z >= test_peak.z) {
                            ok = false;
                            break;
                        }
                    }
                    if (ok) {
                        peaks.push_back(test_peak);
                    }
                }
            }
            

            _map_elevations = new float[_map_size*_map_size];
            std::copy(wrp_->elevations.data.begin(), wrp_->elevations.data.end(), stdext::checked_array_iterator<float *>(_map_elevations, _map_size*_map_size));

            if (strcmp(wrp_->filetype,"8WVR")==0) _generate_peaks(); // These WRP formats do not contain the peaks.

        }

        acre::signal::map::~map()
        {
            if(this->_map_elevations) {
                delete[] this->_map_elevations;
                this->_map_elevations = NULL;
            }
        }

        
        
        float map::elevation(float x_, float y_, float *rd_x_, float *rd_y_)
        {
            float x_rel = x_*_inv_cell_size;
            float y_rel = y_*_inv_cell_size;
            int xi = (int)floor(x_rel);
            int yi = (int)floor(y_rel);
            float x_in = x_rel - xi;
            float y_in = y_rel - yi;
            float z00, z01, z10, z11;
            z00 = _internal_elevation(xi, yi);
            z10 = _internal_elevation(xi + 1, yi);
            z01 = _internal_elevation(xi, yi + 1);
            z11 = _internal_elevation(xi + 1, yi + 1);

            if (x_in <= 1 - y_in) {
                float d1000 = z10 - z00;
                float d0100 = z01 - z00;
                if (rd_x_) {
                    *rd_x_ = d1000*_inv_cell_size;
                    *rd_y_ = d0100*_inv_cell_size;
                }
                return z00 + d0100*y_in + d1000*x_in;
            }
            else {
                // triangle 01,10,11
                float d1011 = z10 - z11;
                float d0111 = z01 - z11;
                if (rd_x_)
                {
                    *rd_x_ = d0111*-_inv_cell_size;
                    *rd_y_ = d1011*-_inv_cell_size;
                }
                return z10 + d0111 - d0111*x_in - d1011*y_in;
            }

            /*
            if (x_in + y_in <= 1) {
                return z00 + (z01 - z00)*y_in + (z10 - z00)*x_in;
            } else {
                return (z01 + z10 - z11) + (z11 - z01)*x_in + (z11 - z10)*y_in;
            }
            */
        }

        float map::elevation(float x_, float y_) {
            return elevation(x_, y_, NULL, NULL);
        }

        glm::vec3 map::normal(float x_, float y_)
        {
            /*
            float x_rel = x_*_inv_cell_size;
            float y_rel = y_*_inv_cell_size;
            int xi = (int)floor(x_rel);
            int yi = (int)floor(y_rel);
            float x_in = x_rel - xi;
            float y_in = y_rel - yi;
            float z00, z01, z10, z11;
            z00 = _internal_elevation(xi, yi);
            z10 = _internal_elevation(xi + 1, yi);
            z01 = _internal_elevation(xi, yi + 1);
            z11 = _internal_elevation(xi + 1, yi + 1);
            glm::vec3 p00 = glm::vec3(xi*_cell_size, yi*_cell_size, z00);
            glm::vec3 p10 = glm::vec3((xi + 1)*_cell_size, yi*_cell_size, z10);
            glm::vec3 p01 = glm::vec3(xi*_cell_size, (yi + 1)*_cell_size, z01);
            glm::vec3 p11 = glm::vec3((xi + 1)*_cell_size, (yi + 1)*_cell_size, z11);

            if (x_in + y_in <= 1) {
                return glm::normalize(glm::vec3(//glm::triangleNormal(p11, p01, p10);
            }
            else {
                return glm::triangleNormal(p00, p10, p01);
            }
            */

            float d_x, d_y;
            elevation(x_, y_, &d_x, &d_y);
            glm::vec3 normal(-d_x, -d_y, 1.0);
            normal = glm::normalize(normal);
            return normal;
        }

        bool map::ground_intersect(const glm::vec3 origin_, const glm::vec3 dir_, const float max_distance_)
        {
            return ground_intersect(origin_, dir_, max_distance_, glm::vec3());
        }

        bool map::ground_intersect(const glm::vec3 origin_, const glm::vec3 dir_, const float max_distance_, glm::vec3 &result_)
        {
            glm::vec3 end_pos = origin_ + dir_ * max_distance_;
            glm::vec3 temp_result;
            std::vector<glm::vec2> grids = _grids_on_line(origin_.x, origin_.y, end_pos.x, end_pos.y);
            glm::vec2 origin_2d = glm::vec2(origin_.x, origin_.y);
            float total_distance_2d = glm::distance(origin_2d, glm::vec2(end_pos.x, end_pos.y));
            for (auto grid_cell : grids) {
                int x, y;
                x = (int)floor((grid_cell.x*_inv_cell_size));
                y = (int)floor((grid_cell.y*_inv_cell_size));

                float cell_max_height = this->_max_grid_height(x, y);
                float line_distance_3d = (glm::distance(origin_2d, grid_cell) / total_distance_2d) * max_distance_;
                float line_height = origin_.z + (dir_.z*line_distance_3d);
                if (line_height < cell_max_height) {
                    float x_rel = grid_cell.x*_inv_cell_size;
                    float y_rel = grid_cell.y*_inv_cell_size;
                    float x_in = x_rel - x;
                    float y_in = y_rel - y;

                    
                    glm::vec3 v10((x + 1)*_cell_size, y*_cell_size, _internal_elevation(x + 1, y));
                    glm::vec3 v01(x*_cell_size, (y + 1)*_cell_size, _internal_elevation(x, y + 1));
                    
                    glm::vec3 v00(x*_cell_size, y*_cell_size, _internal_elevation(x, y));
                    if (glm::intersectLineTriangle(origin_, dir_, v00, v01, v10, temp_result)) {
                        result_ = origin_ + dir_ * temp_result.x;
                        return true;
                    }

                    glm::vec3 v11((x + 1)*_cell_size, (y + 1)*_cell_size, _internal_elevation(x + 1, y + 1));
                    if (glm::intersectLineTriangle(origin_, dir_, v11, v10, v01, temp_result)) {
                        result_ = origin_ + dir_ * temp_result.x;
                        return true;
                    }
                }
            }
            return false;
        }

        void map::terrain_profile(glm::vec3 start_pos_, glm::vec3 end_pos_, float precision_, std::vector<float> &profile_)
        {
            glm::vec3 vector_to = glm::normalize(end_pos_ - start_pos_);

            float distance = glm::distance(start_pos_, end_pos_);
            uint32_t steps = (int)(std::floor(distance / precision_));
            std::vector<float> profile;
            for (uint32_t i = 0; i < steps; ++i) {
                glm::vec3 sample_pos = vector_to * (i * precision_);
                profile_.push_back(this->elevation(sample_pos.x + start_pos_.x, sample_pos.y + start_pos_.y));
            }
        }

        void map::write_cache(std::string bin_path_)
        {
            size_t peak_size = peaks.size();
            std::ofstream bin_file(bin_path_, std::ofstream::binary);
            bin_file.write((char *)&_map_size, sizeof(uint32_t));
            bin_file.write((char *)&_cell_size, sizeof(float));
            bin_file.write((char *)_map_elevations, _map_size*_map_size*sizeof(float));
            bin_file.write((char *)&peak_size, sizeof(size_t));
            for (auto peak : peaks) {
                float x, y, z;
                x = peak.x;
                y = peak.y;
                z = peak.z;
                bin_file.write((char *)&x, sizeof(float));
                bin_file.write((char *)&y, sizeof(float));
                bin_file.write((char *)&z, sizeof(float));
            }

            bin_file.close();
        }

        void map::_generate_peaks()
        {
            std::vector<glm::vec2> first_pass_peaks;

            for (uint32_t x = 0; x < _map_size; ++x) {
                for (uint32_t y = 0; y < _map_size; ++y) {
                    if (_is_peak(x, y)) {
                        float z = _internal_elevation(x, y);
                        if (z > 0.0f) {
                            first_pass_peaks.push_back(glm::vec2(x, y));
                        }
                    }
                }
            }

            float filter_distance = 150;
            std::vector<glm::vec2> filtered_max_peaks;
            int distance = (int)(std::ceil(filter_distance / _cell_size));

            for (auto peak : first_pass_peaks) {
                float peak_height = _internal_elevation((int)peak.x, (int)peak.y);
                int peak_x = (int)peak.x;
                int peak_y = (int)peak.y;
                int offset_x_min = std::max(peak_x - distance, 0);
                int offset_y_min = std::max(peak_y - distance, 0);

                int offset_x_max = std::min(peak_x + distance, (int)_map_size - 1);
                int offset_y_max = std::min(peak_y + distance, (int)_map_size - 1);
                bool is_max = true;
                float average_height = 0;
                int c = 0;
                for (int x_pos = offset_x_min; x_pos <= offset_x_max; ++x_pos) {
                    for (int y_pos = offset_y_min; y_pos <= offset_y_max; ++y_pos) {
                        float test_height = _internal_elevation(x_pos, y_pos);
                        average_height += test_height;
                        if (test_height >= peak_height && x_pos != peak_x && y_pos != peak_y) {
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
                    if (average_height / peak_height > 0.5) {
                        bool not_found = true;
                        for (auto filtered_peak : filtered_max_peaks) {
                            float test_distance = sqrt(pow(peak_x - filtered_peak.x, 2) + pow(peak_y - filtered_peak.y, 2));
                            if ((test_distance*_cell_size) < filter_distance) {
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
            std::vector<glm::vec3> found_peaks;
            for (auto filtered_peak : filtered_max_peaks) {
                peaks.push_back(glm::vec3(filtered_peak.x*_cell_size, filtered_peak.y*_cell_size, _internal_elevation((int)filtered_peak.x, (int)filtered_peak.y)));
            }
        }

        inline float map::_internal_elevation(int x_, int y_)
        {
            return _map_elevations[glm::max((glm::min(x_, (int)_map_size-1)), 0) + glm::max((glm::min(y_, (int)_map_size-1)), 0) * _map_size];
        }

        std::vector<glm::vec2> map::_grids_on_line(float x1_, float y1_, float x2_, float y2_)
        {
            int x1, x2, y1, y2;
            x1 = (int)floor(x1_ / _cell_size);
            y1 = (int)floor(y1_ / _cell_size);
            x2 = (int)floor(x2_ / _cell_size);
            y2 = (int)floor(y2_ / _cell_size);

            int i;               // loop counter 
            int ystep, xstep;    // the step on y and x axis 
            int error;           // the error accumulated during the increment 
            int errorprev;       // *vision the previous value of the error variable 
            int y = y1, x = x1;  // the line points 
            int ddy, ddx;        // compulsory variables: the double values of dy and dx 
            int dx = x2 - x1;
            int dy = y2 - y1;

            std::vector<glm::vec2> points;
            
            POINT(y1, x1);  // first point 
                            // NB the last point can't be here, because of its previous point (which has to be verified) 
            if (dy < 0) {
                ystep = -1;
                dy = -dy;
            }
            else
                ystep = 1;
            if (dx < 0) {
                xstep = -1;
                dx = -dx;
            }
            else
                xstep = 1;
            ddy = 2 * dy;  // work with double values for full precision 
            ddx = 2 * dx;
            if (ddx >= ddy) {  // first octant (0 <= slope <= 1) 
                                // compulsory initialization (even for errorprev, needed when dx==dy) 
                errorprev = error = dx;  // start in the middle of the square 
                for (i = 0; i < dx; i++) {  // do not use the first point (already done) 
                    x += xstep;
                    error += ddy;
                    if (error > ddx) {  // increment y if AFTER the middle ( > ) 
                        y += ystep;
                        error -= ddx;
                        // three cases (octant == right->right-top for directions below): 
                        if (error + errorprev < ddx)  // bottom square also 
                            POINT(y - ystep, x);

                        else if (error + errorprev > ddx)  // left square also 
                            POINT(y, x - xstep);
                        else {  // corner: bottom and left squares also 
                            POINT(y - ystep, x);
                            POINT(y, x - xstep);
                        }
                    }
                    POINT(y, x);
                    errorprev = error;
                }
            }
            else {  // the same as above 
                errorprev = error = dy;
                for (i = 0; i < dy; i++) {
                    y += ystep;
                    error += ddx;
                    if (error > ddy) {
                        x += xstep;
                        error -= ddy;
                        if (error + errorprev < ddy)
                            POINT(y, x - xstep);
                        else if (error + errorprev > ddy)
                            POINT(y - ystep, x);
                        else {
                            POINT(y, x - xstep);
                            POINT(y - ystep, x);
                        }
                    }
                    POINT(y, x);
                    errorprev = error;
                }
            }
            // assert ((y == y2) && (x == x2));  // the last point (y2,x2) has to be the same with the last point of the algorithm 
            
            return points;
        }

        float map::_max_grid_height(int x_, int y_)
        {
            float max_height = _internal_elevation(x_, y_);
            max_height = glm::max(max_height, _internal_elevation(x_ + 1, y_));
            max_height = glm::max(max_height, _internal_elevation(x_ + 1, y_ + 1));
            max_height = glm::max(max_height, _internal_elevation(x_, y_ + 1));

            return max_height;
        }
        bool map::_is_peak(int x_, int y_)
        {
            float height = _internal_elevation(x_, y_);
            int p = 0;
            if (_internal_elevation(x_ - 1, y_ - 1) >= height) p++;
            if (_internal_elevation(x_ - 1, y_) >= height) p++;
            if (_internal_elevation(x_ - 1, y_ + 1) >= height) p++;

            if (_internal_elevation(x_ + 1, y_ - 1) >= height) p++;
            if (_internal_elevation(x_ + 1, y_) >= height) p++;
            if (_internal_elevation(x_ + 1, y_ + 1) >= height) p++;

            if (_internal_elevation(x_, y_ - 1) >= height) p++;
            if (_internal_elevation(x_, y_ + 1) >= height) p++;

            if (p == 8)
                return false;
            if (p == 0)
                return true;
            return false;
        }
    }
}