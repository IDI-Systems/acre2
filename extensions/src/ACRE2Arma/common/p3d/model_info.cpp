#include "p3d/model_info.hpp"
#include "compressed.hpp"
#include "read_helpers.hpp"

namespace acre {
    namespace p3d {
        model_info::model_info() :
            raw_resolutions(nullptr), default_indicators(nullptr)
        { }

        model_info::model_info(std::istream & stream_, const uint32_t lod_count, uint32_t version)
            : raw_resolutions(nullptr), default_indicators(nullptr) {
            
            raw_resolutions = new float[lod_count];
            stream_.read((char *)raw_resolutions, sizeof(float) * lod_count);
            // Get them to parsable int values
            for (uint32_t x = 0; x < lod_count; x++) {
                resolutions.push_back(raw_resolutions[x]);
            }

            stream_.read((char *)&index, sizeof(uint32_t));
            stream_.read((char *)&bounding_sphere, sizeof(float));
            stream_.read((char *)&geo_lod_sphere, sizeof(float));
            stream_.read((char *)&point_flags, sizeof(uint32_t) * 3);

            aiming_center = acre::vector3<float>(stream_);

            stream_.read((char *)&map_icon_color, sizeof(uint32_t));
            stream_.read((char *)&map_selected_color, sizeof(uint32_t));
            stream_.read((char *)&view_density, sizeof(float));

            bbox_min_pos = acre::vector3<float>(stream_);
            bbox_max_pos = acre::vector3<float>(stream_);

            stream_.read((char *)&lod_density_coef, sizeof(float));
            stream_.read((char *)&draw_importance, sizeof(float));

            bbox_visual_min = acre::vector3<float>(stream_);
            bbox_visual_max = acre::vector3<float>(stream_);
            bounding_center = acre::vector3<float>(stream_);
            geometry_center = acre::vector3<float>(stream_);
            centre_of_mass = acre::vector3<float>(stream_);

            inv_inertia[0] = acre::vector3<float>(stream_);
            inv_inertia[1] = acre::vector3<float>(stream_);
            inv_inertia[2] = acre::vector3<float>(stream_);

            READ_BOOL(autocenter);
            READ_BOOL(lock_autocenter);
            READ_BOOL(can_occlude);
            READ_BOOL(can_be_occluded);
            if (version >= 73) {
                READ_BOOL(ai_cover);
            }

            // Skeleton stuff
            float tempBool;
            stream_.read((char *)&tempBool, sizeof(float));
            stream_.read((char *)&tempBool, sizeof(float));
            stream_.read((char *)&tempBool, sizeof(float));
            stream_.read((char *)&tempBool, sizeof(float));
            stream_.read((char *)&tempBool, sizeof(float));
            stream_.read((char *)&tempBool, sizeof(float));

            READ_BOOL(force_not_alpha);
            stream_.read((char *) &source, sizeof(int32_t));

            READ_BOOL(prefer_shadow_volume);
            stream_.read((char *)&shadow_offset, sizeof(float));

            READ_BOOL(animated);

            // Parse the full skeletal structure
            skeleton = std::make_shared<acre::p3d::skeleton>(stream_, lod_count);

            stream_.read((char *)&map_type, sizeof(char));

            uint32_t n_floats;
            stream_.read((char *) &n_floats, sizeof(uint32_t));

            stream_.read((char *)&mass, sizeof(float));
            stream_.read((char *)&mass_reciprocal, sizeof(float));
            stream_.read((char *)&armor, sizeof(float));
            stream_.read((char *)&inv_armor, sizeof(float));

            if (version >= 72) {
                stream_.read((char *)&explosion_shielding, sizeof(float));
            }

            stream_.read((char *)&special_lod_indeces, sizeof(uint8_t) * 14);
            
            stream_.read((char *)&min_shadow, sizeof(uint32_t));
            READ_BOOL(can_blend);

            READ_STRING(class_type);
            READ_STRING(destruct_type);
            READ_BOOL(property_frequent);

            uint32_t always_0;
            stream_.read((char *)&always_0, sizeof(uint32_t));

            for (uint32_t nLods = 0; nLods < lod_count; nLods++) {
                uint8_t junk[12];
                stream_.read((char *)&junk, sizeof(uint8_t) * 12);
                std::cout << junk[12] << std::endl;
            }
        }

        model_info::~model_info() {
            if (raw_resolutions) {
                delete[] raw_resolutions;
            }
            if (default_indicators) {
                delete[] default_indicators;
            }
        }
    }
}
