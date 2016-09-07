#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        weapons[] = { RADIO_WEAPON_LIST_STR(ACRE_PRC148), RADIO_WEAPON_LIST_STR(ACRE_PRC148_UHF) };
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
#include "prc148_RadioDialog.hpp"
