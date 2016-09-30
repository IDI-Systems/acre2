#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(basicSetup)};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            DOUBLES(PREFIX,main),
            DOUBLES(PREFIX,sys_prc117f),
            DOUBLES(PREFIX,sys_prc152),
            DOUBLES(PREFIX,sys_prc148),
            DOUBLES(PREFIX,sys_prc77),
            DOUBLES(PREFIX,sys_prc343),
            "acre_sys_core"
        };
        version = VERSION;
        AUTHOR;
        authors[] = {"Jaynus", "Nou"};
        authorUrl = URL;
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgAcreAPI.hpp"
#include "CfgModules.hpp"
