#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        weapons[] = { RADIO_WEAPON_LIST_STR(ACRE_PRC343) };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_sys_radio" };
        version = VERSION;
        AUTHOR;
        authors[] = {"Jaynus", "Nou"};
        authorUrl = URL;
    };
};

PRELOAD_ADDONS;

#include "CfgWeapons.hpp"
#include "CfgAcreRadios.hpp"

#include "CfgEventHandlers.hpp"
#include "DialogDefines.hpp"
#include "RadioDialogClasses.hpp"
#include "prc343_RadioDialog.hpp"
