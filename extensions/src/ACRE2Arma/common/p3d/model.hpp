#pragma once

#include "shared.hpp"

#include "animation.hpp"
#include "skeleton.hpp"
#include "model_info.hpp"
#include "lod_info.hpp"

namespace acre {
    namespace p3d {
        class face_settings {
        public:
            face_settings() {}
            face_settings(std::istream &stream_, uint32_t version = 73) {
                stream_.read((char *)&num_faces, sizeof(uint32_t));
                stream_.read((char *)&icon_color, sizeof(uint32_t));
                stream_.read((char *)&special, sizeof(uint32_t));
                stream_.read((char *)&or_hint, sizeof(uint32_t));
                READ_BOOL(skeletonToSubskeletonEmpty);
                stream_.read((char *)&num_points, sizeof(uint32_t));
                stream_.read((char *)&face_area, sizeof(uint32_t));
            }

            uint32_t num_faces;
            uint32_t icon_color;
            uint32_t special;
            uint32_t or_hint;
            bool skeletonToSubskeletonEmpty;
            uint32_t num_points;
            uint32_t face_area;
        };
        typedef std::shared_ptr<face_settings> face_settings_p;
        
        class model {
        public:
            model();
            model(std::istream &, const std::string &filename_ = "");
            ~model();

            // LOD info
            bool                                *useFaceDefaults;
            std::vector<face>                   defaultFaces;
            std::vector<lod_p>                  lods;

            std::streampos                      size;
            model_info_p                        info;
            skeleton_p                          skeleton;

            bool                                has_animations;
            std::vector<animation_p>            animations;
            

            std::vector<uint32_t>               start_lod;
            std::vector<uint32_t>               end_lod;

            // data root fileds
            std::string                         filename;
            uint32_t                            lod_count;
            uint32_t                            filetype;
            uint32_t                            version;
            std::string                         prefix_name;

        };
        typedef std::shared_ptr<model> model_p;
    }
}
