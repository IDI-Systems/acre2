#pragma once

#include "shared.hpp"
#include "vector.hpp"
#include "skeleton.hpp"
#include "lod_types.hpp"
#include <sstream>

namespace acre {
    namespace p3d {
        enum class SBSource : uint32_t {
            Visual,
            ShadowVolume,
            Explicit,
            None
        };

        enum class MapType : uint32_t {
            Tree,
            SmallTree,
            Bush,
            Building,
            House,
            ForestBorder,
            ForestTriangle,
            ForestSquare,
            Church,
            Chapel,
            Cross,
            Rock,
            Bunker,
            Fortress,
            Fountain,
            ViewTower,
            Lighthouse,
            Quay,
            Fuelstation,
            Hospital,
            Fence,
            Wall,
            Hide, //default value
            BusStop,
            Road,
            Forest,
            Transmitter,
            Stack,
            Ruin,
            Tourism,
            Watertower,
            Track,
            MainRoad,
            Rocks,
            PowerLines,
            RailWay,
            PowerSolar,
            PowerWave,
            PowerWind,
            Shipwreck,
            NMapType
        };

        class model_info {
        public:
            model_info();
            model_info(std::istream &, const uint32_t lod_count, uint32_t version = 73);
            ~model_info();

            std::vector<float>  resolutions;
            float               *raw_resolutions;      // LodTypes[Header.NoOfLods];// alias resolutions

            uint32_t            index;                 // appears to be a bit flag, 512, 256 eg
            float               bounding_sphere;
            float               geo_lod_sphere;        // mostly same as MemLodSphere
            uint32_t            point_flags[3];        // typically 00 00 00 00  00 00 00 00 00 00 0C 00 eg (last is same as user point flags)
            acre::vector3<float> aiming_center;         // Aiming center (previously offset_1)
            uint32_t            map_icon_color;        // RGBA 32 color
            uint32_t            map_selected_color;    // RGBA 32 color
            float               view_density;          //

            acre::vector3<float> bbox_min_pos;          // minimum coordinates of bounding box
            acre::vector3<float> bbox_max_pos;          // maximum coordinates of bounding box. Generally the complement of the 1st
                                                        // pew.GeometryBounds in Pew is bboxMinPosition-bboxMaxPosition for X and Z
                                                        // pew.ResolutionBounds mostly the same
            float lod_density_coef;
            float draw_importance;

            acre::vector3<float> bbox_visual_min;
            acre::vector3<float> bbox_visual_max;
            acre::vector3<float> bounding_center;
            acre::vector3<float> geometry_center;
            acre::vector3<float> centre_of_mass;

            acre::vector3<float> inv_inertia[3];        // for ODOL7 this is a mixture of floats and index values
                                                       //// if Arma3 /////////////////
            ///////////////////////////////
            bool                autocenter;
            bool                lock_autocenter;
            bool                can_occlude;
            bool                can_be_occluded;
     
            bool                ai_cover;
            bool                force_not_alpha;
            SBSource            source;
            bool                prefer_shadow_volume;
            float               shadow_offset;

            bool                animated;
            skeleton_p          skeleton;              //
            MapType             map_type;

            float               mass;
            float               mass_reciprocal;       // see note
            float               armor;                 // see note
            float               inv_armor;             // see note
            float               explosion_shielding;

            uint8_t             special_lod_indeces[14];  // see note generally FF FF FF FF FF FF FF FF FF FF FF FF
            uint32_t            min_shadow;
            bool                can_blend;

            std::string         class_type;            // asciiz      ClassType;                // class="House" See Named Properties
            std::string         destruct_type;         //DestructType;             // damage="Tent" See Named Properties
            bool                property_frequent;     // rarely true

            uint32_t            number_graphical_lods;

            uint8_t             shadowVolume;
            uint8_t             shadowBuffer;
            uint32_t            shadowVolumeCount;
            uint32_t            shadowBufferCount;
            bool                u_bool_3;              // rarely true
            uint32_t            u_long_2;              //
            uint8_t             *default_indicators;   //default_indicators[NoOfLods][12]; //generally FF FF FF FF FF FF FF FF FF FF FF FF
        };
        typedef std::shared_ptr<model_info> model_info_p;

    }
}
