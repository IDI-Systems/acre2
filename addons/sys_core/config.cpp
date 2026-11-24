#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_io", "acre_sys_data"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};
#include "CfgEden.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
#include "RscMicTest.hpp"

class CfgAcreWorlds {

};

