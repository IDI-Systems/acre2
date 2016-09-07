#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        weapons[] = { RADIO_WEAPON_LIST_STR(ACRE_PRC77) };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_sys_radio" };
        version = VERSION;
        AUTHOR;
        authors[] = {"Jaynus", "Nou", "Soldia"};
        authorUrl = URL;
    };
};

PRELOAD_ADDONS;

class CfgVehicles {

    class B_Kitbag_mcamo;
    class ACRE_testBag : B_Kitbag_mcamo {
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
