#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Data_F_Tank_Loadorder",
            // CBA
            "cba_main",
            "cba_xeh"
        };
        author = CSTRING(Author);
        url = CSTRING(URL);
        VERSION_CONFIG;
    };

    // Backwards compatibility
    class acre_game: ADDON {author = "";}; // Component removed in 2.3.0
};

class CfgMods {
    class ACRE2 {
        dir = "@ACRE2";
        picture = "idi\acre\addons\main\acre2_large-logo.paa";
        action = "https://github.com/IDI-Systems/acre2";
        hideName = 0;
        hidePicture = 0;
        name = "ACRE2";
    };
};

#include "CfgRscStd.hpp"
#include "CfgSettings.hpp"

#include "CfgEventHandlers.hpp"
#include "CfgLocationTypes.hpp"
#include "CfgWeapons.hpp"
