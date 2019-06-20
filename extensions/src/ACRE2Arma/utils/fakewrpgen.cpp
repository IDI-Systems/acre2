/************* SQF code

private _mapSize = worldSize;                // Read in CfgWorlds. For Tanoa 15360
private _gridSize = 4096;                    // gridSize 4096*4096 - 63mb for native float.
private _interval = _mapSize / _gridSize;    // For Tanoa: 3.75


for "_y" from 0 to (_mapSize - _interval) step _interval do {
   private _heights = "";
   for "_x" from 0 to (_mapSize - _interval) step _interval do {
       _heights = _heights + format['%1,',(getTerrainHeightASL [_x,_y])];
   };
   "ace_clipboard" callExtension _heights;
};

"ace_clipboard" callExtension "--COMPLETE--"
*/

#include <cstdint>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <string>
#include <regex>
#include <algorithm>

#include "logging.hpp"
#include "wrp/landscape.hpp"
#include "Types.h"
#include "glm/glm.hpp"

static bool generateWrpFile(acre::wrp::landscape &wrpOut_, std::unordered_map<std::string, std::string> &config_);
static bool readHeightFile(float32_t *const heightmap_, const uint32_t maxSize, const std::string &filename_);

static void calculatePeaks(acre::wrp::landscape &wrp_);
static float32_t internal_elevation(const int32_t x_, const int32_t y_, const acre::wrp::landscape &wrp_);
static bool is_peak(const int32_t x_, const int32_t y_, const acre::wrp::landscape &wrp_);

struct membuf : std::streambuf {
    membuf(char* begin, char* end) {
        this->setg(begin, begin, end);
    }
};

INITIALIZE_EASYLOGGINGPP

int main(int argc, char **argv) {
    if (argc != 2) {
        return 0;
    }

    /*
     *  Options are:
     *  - task:
     *    - "convert": a wrp file is converted to ACRE wrp.
     *    - "generate": a fakewrp file is generated from a plain file containing elevations
     *  - input_file: file to read. Either .wrp or .csv
     *  - output_file: fakewrp
     *  The following options are only used if creating a fakewrp from csv
     *  - layer_size_x: Layer size X direction
     *  - layer_size_y: Layer size Y direction
     *  - map_size_x: Map size X direction
     *  - map_size_y: Map size Y direction
     *  - version: wrp layout version
     *  - world_size: World size
     */

    std::unordered_map<std::string, std::string> config;
    std::ifstream config_file(argv[1]);
    if (config_file.is_open()) {
        std::string line;
        std::smatch matches;
        std::regex exp("(\\w+?)\\s+?=\\s*([^\\s].*)");
        while (std::getline(config_file, line)) {
            if (std::regex_match(line.cbegin(), line.cend(), matches, exp)) {
                std::cout << matches[1] << ": " << matches[2] << "\n";
                config[matches[1].str()] = matches[2].str();
            }
        }
        config_file.close();
    } else {
        return 0;
    }

    std::string outputFile;
    acre::wrp::landscape wrpOut;

    if (config["task"] == "convert") {
        wrpOut.parse(config["input_file"]);

        if (strcmp(wrpOut.filetype, "8WVR") == 0) {
            calculatePeaks(wrpOut);
        }
    } else {
        generateWrpFile(wrpOut, config);
    }
    
    std::ofstream wrpOutput(config["output_file"], std::ios::binary);

    if (!wrpOutput.is_open()) {
        std::cerr << "Could not open: " << config["output_file"] << std::endl;
        return 0;
    }

    acre::Result result = wrpOut.generateAcreWrp(wrpOutput);

    if (result != acre::Result::ok) {
        std::cerr << "Error writing to: " << config["output_file"] << std::endl;
    }
    
    wrpOutput.close();

    return 0;
}

static bool generateWrpFile(acre::wrp::landscape &wrpOut_, std::unordered_map<std::string, std::string> &config_) {
    wrpOut_.layer_size_x = static_cast<uint32_t>(std::stoul(config_["layer_size_x"]));
    wrpOut_.layer_size_y = static_cast<uint32_t>(std::stoul(config_["layer_size_y"]));

    wrpOut_.map_size_x = static_cast<uint32_t>(std::stoul(config_["map_size_x"]));
    wrpOut_.map_size_y = static_cast<uint32_t>(std::stoul(config_["map_size_y"]));

    wrpOut_.version = static_cast<uint32_t>(std::stoul(config_["version"]));
    wrpOut_.cell_size = std::stof(config_["world_size"])/ wrpOut_.layer_size_x;

    // Elevations
    float32_t *heightmap = new float32_t[wrpOut_.map_size_x * wrpOut_.map_size_y];
    if (!readHeightFile(heightmap, wrpOut_.map_size_x * wrpOut_.map_size_y, config_["input_file"])) {
        return false;
    }

    membuf sbuf((char *) heightmap, (char *) heightmap + sizeof(heightmap));
    std::istream stream(&sbuf);
    wrpOut_.elevations = acre::wrp::compressed<float32_t>(stream, wrpOut_.map_size_x * wrpOut_.map_size_y, false, false, wrpOut_.version);

    // Peaks
    calculatePeaks(wrpOut_);

    return true;
}

static bool readHeightFile(float32_t *const heightmap_, const uint32_t maxSize_, const std::string &filename_) {
    std::ifstream inFile(filename_);

    if (!inFile.is_open()) {
        return false;
    }

    std::string line;

    std::getline(inFile, line, ',');
    line.erase(std::remove(line.begin(), line.end(), '\0'), line.end());
    heightmap_[0] = std::stof(line, nullptr);

    size_t heightIdx = 1;
    while (!inFile.eof() && heightIdx < maxSize_) {
        std::getline(inFile, line, ',');
        line.erase(std::remove(line.begin(), line.end(), '\0'), line.end());
        heightmap_[heightIdx] = std::stof(line, nullptr);

        heightIdx++;
    }

    inFile.close();

    return true;
}

// Shamelessly use the code in map.cpp
static void calculatePeaks(acre::wrp::landscape &wrpOut) {
    std::vector<glm::vec2> first_pass_peaks;

    for (uint32_t x = 0u; x < wrpOut.map_size_x; ++x) {
        for (uint32_t y = 0u; y < wrpOut.map_size_y; ++y) {
            if (is_peak(x, y, wrpOut)) {
                const float32_t z = internal_elevation(x, y, wrpOut);
                if (z > 0.0f) {
                    first_pass_peaks.push_back(glm::vec2(x, y));
                }
            }
        }
    }

    const float32_t filter_distance = 30.0f;  // Original value 150.0f
    std::vector<glm::vec2> filtered_max_peaks;
    int32_t distance = static_cast<int32_t>(ceilf(filter_distance / wrpOut.cell_size));

    for (auto peak : first_pass_peaks) {
        const int32_t peak_x = static_cast<int32_t>(peak.x);
        const int32_t peak_y = static_cast<int32_t>(peak.y);
        float32_t peak_height = internal_elevation(peak_x, peak_y, wrpOut);

        const int32_t offset_x_min = std::max(peak_x - distance, 0);
        const int32_t offset_y_min = std::max(peak_y - distance, 0);

        const int32_t offset_x_max = std::min(peak_x + distance, static_cast<int32_t>(wrpOut.map_size_x - 1u));
        const int32_t offset_y_max = std::min(peak_y + distance, static_cast<int32_t>(wrpOut.map_size_y - 1u));
        bool is_max = true;
        float32_t average_height = 0;
        int32_t c = 0;
        for (int32_t x_pos = offset_x_min; x_pos <= offset_x_max; ++x_pos) {
            for (int32_t y_pos = offset_y_min; y_pos <= offset_y_max; ++y_pos) {
                const float32_t test_height = internal_elevation(x_pos, y_pos, wrpOut);
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
                    if ((test_distance * wrpOut.cell_size) < filter_distance) {
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
        const float32_t elev = internal_elevation(static_cast<int32_t>(filtered_peak.x), static_cast<int32_t>(filtered_peak.y), wrpOut);
        const acre::vector3<float32_t> peak(filtered_peak.x * wrpOut.cell_size, filtered_peak.y * wrpOut.cell_size, elev);
        wrpOut.peaks.push_back(peak);
    }
}

static float32_t internal_elevation(const int32_t x_, const int32_t y_, const acre::wrp::landscape &wrp_) {
    return wrp_.elevations.data[glm::max((glm::min(x_, static_cast<int32_t>(wrp_.map_size_x - 1u))), 0)
        + glm::max((glm::min(y_, static_cast<int32_t>(wrp_.map_size_x - 1u))), 0)
        * wrp_.map_size_x];
}

static bool is_peak(const int32_t x_, const int32_t y_, const acre::wrp::landscape &wrp_) {
    const float32_t height = internal_elevation(x_, y_, wrp_);
    uint8_t p = 0;

    if (internal_elevation(x_ - 1, y_ - 1, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_ - 1, y_, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_ - 1, y_ + 1, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_ + 1, y_ - 1, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_ + 1, y_, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_ + 1, y_ + 1, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_, y_ - 1, wrp_) >= height) {
        p++;
    }
    if (internal_elevation(x_, y_ + 1, wrp_) >= height) {
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
