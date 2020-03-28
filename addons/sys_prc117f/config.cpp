#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {RADIO_WEAPON_LIST_STR(ACRE_PRC117F)};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_radio", "acre_sys_fonts"};
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgWeapons.hpp"
#include "CfgAcreRadios.hpp"
#include "CfgEventHandlers.hpp"
#include "DialogDefines.hpp"
#include "RadioDialogClasses.hpp"
#include "prc117f_RadioDialog.hpp"
