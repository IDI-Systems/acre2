#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = { RADIO_WEAPON_LIST_STR(ACRE_SEM70) };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_sys_radio" };
        author = ECSTRING(main,Author);
        authors[] = {"Raspu"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgWeapons.hpp"
#include "CfgAcreRadios.hpp"

#include "CfgEventHandlers.hpp"
#include "MyDialogDefines.hpp"
#include "RadioDialogClasses.hpp"
#include "sem70_RadioDialog.hpp"
