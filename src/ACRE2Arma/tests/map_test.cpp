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
                                      for(int x = 0; x < 2056;x++) { char byte = 0; stream_.read((char *)&byte, 1);  if(byte == 0x00) break; ss << byte;  } \
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
	std::string wrp_path = "\\ca\\takistan\\takistan.wrp";
	std::string pbo_path = "C:\\Steam\\SteamApps\\common\\Arma 3\\@UOMAPS_A3_CUP\\addons\\takistan.pbo";

	_filestream.open(pbo_path, std::ios::binary | std::ios::in);
	acre::signal::map_p test_map;
	bool loaded;
	bool ok = acre::signal::map_loader::get().get_map(wrp_path, test_map, loaded);
	return 0;
	int offset_x = 0;
	int offset_y = 0;
	int size_x = -1;
	int size_y = -1;
	int scale = 2;

	offset_x = offset_x * scale;
	offset_y = offset_y * scale;
	if (size_x > 0) {
		size_x = size_x * scale;
	}
	else {
		size_x = test_map->map_size() * scale;
	}
	if (size_y > 0) {
		size_y = size_y * scale;
	}
	else {
		size_y = test_map->map_size() * scale;
	}

	int map_size = test_map->map_size()*scale;
	float cell_sample_size = test_map->cell_size() / scale;
	bitmap_image image(size_x, size_y);
	bitmap_image land_grad("d:\\land_grad.bmp");
	bitmap_image sea_grad("d:\\sea_grad.bmp");



	float min_height = 10000.0f;
	float max_height = -10000.0f;
	for (int x = 0; x < test_map->map_size(); ++x) {
		for (int y = 0; y < test_map->map_size(); ++y) {
			float height = test_map->elevation_raw(x, y);
			max_height = std::max(max_height, height);
			min_height = std::min(min_height, height);
		}
	}
	bool ack = false;
	uint32_t total_size = map_size * map_size;
	glm::vec3 light_source = glm::vec3(-1.0f, -1.0f, 0.5f);
	light_source = glm::normalize(light_source);
	for (int y = offset_y; y < std::min(offset_y + size_y, map_size - scale); ++y) {
		for (int x = offset_x; x < std::min(offset_x + size_x, map_size - scale); ++x) {

			uint8_t colorR, colorG, colorB;
			float r_x, r_y;
			float height = test_map->elevation((float)x * cell_sample_size, (float)y * cell_sample_size, &r_x, &r_y);

			//glm::vec3 normal = test_map->normal((float)x * cell_sample_size, (float)y * cell_sample_size);

			glm::vec3 normal = glm::normalize(glm::vec3(-r_x, -r_y, 1.0f));
			float factor = glm::dot(normal, -light_source);
			
			if (height > 0.0f) {
				//r.R = fg.R * fg.A / r.A + bg.R * bg.A * (1 - fg.A) / r.A; // 0.67
				//r.G = fg.G * fg.A / r.A + bg.G * bg.A * (1 - fg.A) / r.A; // 0.33
				//r.B = fg.B * fg.A / r.A + bg.B * bg.A * (1 - fg.A) / r.A; // 0.00
				int8_t shade = 254 * std::min(factor, 0.0f);
				uint8_t shadow = 254 + shade;
				uint8_t color_index = (height / max_height) * 254;

				land_grad.get_pixel(color_index, 0, colorR, colorG, colorB);
				//colorR = colorG = colorB = 254;
				float r, g, b, fa, s, ra, ba;
				
				fa = 0.5f;
				ba = 1.0f - fa;
				r = colorR / 255.0f;
				g = colorG / 255.0f;
				b = colorB / 255.0f;
				s = shadow / 255.0f;

				ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75

				r = s * fa / ra + r * ba * (1.0f - fa) / ra;
				g = s * fa / ra + g * ba * (1.0f - fa) / ra;
				b = s * fa / ra + b * ba * (1.0f - fa) / ra;


				colorR = r * 254;
				colorG = g * 254;
				colorB = b * 254;

				//colorR = colorG = colorB = color_index + shadow;
			}
			else {
				int8_t shade = 127 * factor;
				uint8_t shadow = 127 + shade;
				uint8_t color_index = (1.0f - (std::abs(height) / std::abs(min_height))) * 254;

				sea_grad.get_pixel(color_index, 0, colorR, colorG, colorB);

				float r, g, b, fa, s, ra, ba;

				fa = 0.35f;
				ba = 1.0f - fa;
				r = colorR / 255.0f;
				g = colorG / 255.0f;
				b = colorB / 255.0f;
				s = shadow / 255.0f;

				ra = 1.0f - (1.0f - fa) * (1.0f - ba); // 0.75

				r = s * fa / ra + r * ba * (1.0f - fa) / ra;
				g = s * fa / ra + g * ba * (1.0f - fa) / ra;
				b = s * fa / ra + b * ba * (1.0f - fa) / ra;


				colorR = r * 254;
				colorG = g * 254;
				colorB = b * 254;
				//colorR = colorG = colorB = 254;
			}
			image.set_pixel(x - offset_x, (size_y-1)-(y - offset_y), colorR, colorG, colorB);
		}
	}
	image.save_image("d:\\output.bmp");
	//getchar();
	return 0;
}