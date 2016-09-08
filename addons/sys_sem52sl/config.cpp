#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        weapons[] = { RADIO_WEAPON_LIST_STR(ACRE_SEM52SL) };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_sys_radio" };
        version = VERSION;
        AUTHOR;
        authors[] = {"Raspu"};
        authorUrl = URL;
    };
};

PRELOAD_ADDONS;

#include "CfgWeapons.hpp"
#include "CfgAcreRadios.hpp"

#include "CfgEventHandlers.hpp"
#include "MyDialogDefines.hpp"
#include "RadioDialogClasses.hpp"
#include "sem52sl_RadioDialog.hpp"
