#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(basicMissionSetup), QGVAR(nameChannels)};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "acre_main",
            "acre_sys_prc117f",
            "acre_sys_prc152",
            "acre_sys_prc148",
            "acre_sys_prc77",
            "acre_sys_prc343",
            "acre_sys_core",
            "acre_sys_godmode",
            "acre_sys_radio"
        };
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgAcreAPI.hpp"
#include "CfgModules.hpp"
