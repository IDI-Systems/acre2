#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {RADIO_WEAPON_LIST_STR(ACRE_PRC77)};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_radio"};
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou", "Soldia"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

class CfgVehicles {

    class B_Kitbag_mcamo;
    class ACRE_testBag: B_Kitbag_mcamo {
        allowedSlots[] = {701, 801, 901};
        displayName = "ACRE TEST BAG";
    };
};

#include "CfgWeapons.hpp"
#include "CfgAcreRadios.hpp"


#include "CfgEventHandlers.hpp"
#include "DialogDefines.hpp"
#include "RadioDialogClasses.hpp"
#include "prc77_RadioDialog.hpp"
