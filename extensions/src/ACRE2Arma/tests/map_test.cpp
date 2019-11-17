#include "shared.hpp"
#include "pbo\archive.hpp"
#include "membuf.hpp"
#include "logging.hpp"
#include "map\map.hpp"
#include <iostream>
#include <fstream>
#include <thread>

#include "antenna\antenna_library.hpp"
#include "models\los_simple.hpp"
#include "glm\geometric.hpp"
#include "glm\gtx\vector_angle.hpp"
#include "wrp\landscape.hpp"
#include "bitmap_image.hpp"
#include "glm\gtx\gradient_paint.hpp"


INITIALIZE_EASYLOGGINGPP

#define READ_STRING(output) { \
                                    std::stringstream ss; \
                                      for (int32_t x = 0; x < 2056;x++) { char byte = 0; stream_.read((char *)&byte, 1);  if (byte == 0x00) break; ss << byte;  } \
                                    output = ss.str(); \
                                    }

struct signal_map {


};



int main(int argc, char **argv) {
    std::ifstream _filestream;
    //std::string wrp_path = "\\a3\\map_altis\\Altis.wrp";
    //std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\Addons\\map_altis.pbo";
    /*std::string wrp_path = "\\WL\\WL_Route191\\WL_Route191.wrp";
    std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\@UOMAPS_A3\\addons\\wl_route191.pbo";*/
    //std::string wrp_path = "\\ca\\sara\\sara.wrp";
    //std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\@UOMAPS_A3\\addons\\sara.pbo";
    //std::string wrp_path = "\\ca\\chernarus\\chernarus.wrp";
    //std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\@UOMAPS_A3_CUP\\addons\\chernarus.pbo";
    //std::string wrp_path = "\\ca\\takistan\\takistan.wrp";
    //std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\@UOMAPS_A3_CUP\\addons\\takistan.pbo";
	//std::string wrp_path = "\\WW2\\Terrains_w\\Worlds\\Ivachev_w\\Ivachev.wrp";
	//std::string pbo_path = "C:\\Program Files (x86)\\Steam\\SteamApps\\common\\Arma 3\\!Workshop\\@IFA3LITE\\addons\\ww2_terrains_w_worlds_ivachev_w.pbo";
	//std::string wrp_path = "\\a3\\map_altis\\Altis.wrp";
	//std::string pbo_path = "C:\\Program Files (x86)\\Steam\\SteamApps\\common\\Arma 3\\Addons\\map_altis.pbo";

    std::string pbo_path = "F:\\Steam\\steamapps\\common\\Arma 3\\Addons\\map_stratis.pbo";
    std::string wrp_path = "\\a3\\map_stratis\\Stratis.wrp";
    //const std::string wrp_path(argv[1]);
    //const std::string pbo_path(argv[2]);
	//std::string wrp_path = "\\ca\\afghan\\Mountains_ACR.wrp";
	//std::string pbo_path = "C:\\Program Files (x86)\\Steam\\SteamApps\\common\\Arma 3\\swifty\\@cup_terrains\\addons\\cup_terrains_maps_afghan.pbo";

    _filestream.open(pbo_path, std::ios::binary | std::ios::in);
    acre::signal::map_p test_map;
    bool loaded;
    acre::wrp::LandscapeResult ok = acre::signal::map_loader::get().get_map(wrp_path, test_map, loaded);
    int32_t offset_x = 0;
    int32_t offset_y = 0;
    int32_t size_x = -1;
    int32_t size_y = -1;
    int32_t scale = 1;

    offset_x = offset_x * scale;
    offset_y = offset_y * scale;

    if (size_x > 0) {
        size_x = size_x * scale;
    } else {
        size_x = test_map->map_size() * scale;
    }

    if (size_y > 0) {
        size_y = size_y * scale;
    } else {
        size_y = test_map->map_size() * scale;
    }

    const int32_t map_size = test_map->map_size()*scale;
    const float32_t cell_sample_size = test_map->cell_size()/scale;

    bitmap_image image(size_x, size_y);
    //bitmap_image land_grad("d:\\land_grad.bmp");
    //bitmap_image sea_grad("d:\\sea_grad.bmp");

    float32_t min_height = 10000.0f;
    float32_t max_height = -10000.0f;
    for (uint32_t x = 0; x < test_map->map_size(); ++x) {
        for (uint32_t y = 0; y < test_map->map_size(); ++y) {
            const float32_t height = test_map->elevation_raw(x, y);
            max_height = std::max(max_height, height);
            min_height = std::min(min_height, height);
        }
    }

    uint32_t total_size = map_size * map_size;
    glm::vec3 light_source = glm::vec3(-1.0f, -1.0f, 0.5f);
    light_source = glm::normalize(light_source);
    for (int32_t y = offset_y; y < std::min(offset_y + size_y, map_size - scale); ++y) {
        for (int32_t x = offset_x; x < std::min(offset_x + size_x, map_size - scale); ++x) {
            float32_t r_x = 0.0f, r_y = 0.0f;
            const float32_t height = test_map->elevation(static_cast<float32_t>(x) * cell_sample_size, static_cast<float32_t>(y) * cell_sample_size, &r_x, &r_y);

            //glm::vec3 normal = test_map->normal((float)x * cell_sample_size, (float)y * cell_sample_size);

            const glm::vec3 normal = glm::normalize(glm::vec3(-r_x, -r_y, 1.0f));
            const float32_t factor = glm::dot(normal, -light_source);

            float32_t colorR = 0.0f;
            float32_t colorG = 0.0f;
            float32_t colorB = 0.0f;

            if (height > 0.0f) {
                //r.R = fg.R * fg.A / r.A + bg.R * bg.A * (1 - fg.A) / r.A; // 0.67
                //r.G = fg.G * fg.A / r.A + bg.G * bg.A * (1 - fg.A) / r.A; // 0.33
                //r.B = fg.B * fg.A / r.A + bg.B * bg.A * (1 - fg.A) / r.A; // 0.00
                const float32_t shade = 254.0f * std::min(factor, 0.0f);
                const float32_t shadow = 254.0f + shade;
                const float32_t color_index = height / max_height;

                colorR = (1.0f - color_index) * 248.0f + color_index * 104.0f;
                colorG = (1.0f - color_index) * 218.0f + color_index * 75.0f;
                colorB = (1.0f - color_index) * 150.0f + color_index * 13.0f;
                //land_grad.get_pixel(color_index, 0, colorR, colorG, colorB);
                //colorR = colorG = colorB = 254;
                
                const float32_t fa = 0.5f;
                const float32_t ba = 1.0f - fa;
                float32_t r = colorR / 255.0f;
                float32_t g = colorG / 255.0f;
                float32_t b = colorB / 255.0f;
                const float32_t s = shadow / 255.0f;

                const float32_t ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75
                r = s * fa / ra + r * ba * (1.0f - fa) / ra;
                g = s * fa / ra + g * ba * (1.0f - fa) / ra;
                b = s * fa / ra + b * ba * (1.0f - fa) / ra;

                colorR = r * 254.0f;
                colorG = g * 254.0f;
                colorB = b * 254.0f;

                //colorR = colorG = colorB = color_index + shadow;
            } else {
                const float32_t shade = 127.0f * factor;
                const float32_t shadow = 127.0f + shade;
                const float32_t color_index = (1.0f - (std::abs(height) / std::abs(min_height)));

                colorR = (1.0f - color_index) * 25.0f + color_index * 172.0f;
                colorG = (1.0f - color_index) * 79.0f + color_index * 224.0f;
                colorB = (1.0f - color_index) * 107.0f + color_index * 251.0f;
                //sea_grad.get_pixel(static_cast<uint32_t>(color_index), 0, colorR, colorG, colorB);

                const float32_t fa = 0.35f;
                const float32_t ba = 1.0f - fa;
                float32_t r = colorR / 255.0f;
                float32_t g = colorG / 255.0f;
                float32_t b = colorB / 255.0f;
                const float32_t s = shadow / 255.0f;

                const float32_t ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75

                r = s * fa / ra + r * ba * (1.0f - fa) / ra;
                g = s * fa / ra + g * ba * (1.0f - fa) / ra;
                b = s * fa / ra + b * ba * (1.0f - fa) / ra;

                colorR = static_cast<uint8_t>(r * 254.0f);
                colorG = static_cast<uint8_t>(g * 254.0f);
                colorB = static_cast<uint8_t>(b * 254.0f);
                //colorR = colorG = colorB = 254;
            }
            image.set_pixel(x - offset_x, (size_y - 1) - (y - offset_y), static_cast<uint8_t>(colorR), static_cast<uint8_t>(colorG), static_cast<uint8_t>(colorB));
        }
    }
    image.save_image("d:\\output.bmp");

    return 0;
}
