#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = { "acre_main", "acre_sys_core", "acre_sys_io" };
		version = VERSION;
		AUTHOR;
	};
};
#include "cfgEventhandlers.hpp"

// Debug and setup wizard windows
#include "MyDialogDefines.hpp"
#include "ACRE_OmnibusWizardBases.hpp"
#include "ACRE_OmnibusWizardMain.hpp"

class CfgVehicles {
    class VR_Block_base_F;
    class acre_test_box : VR_Block_base_F {
		mapSize = 7.5;
		author = "$STR_A3_Bohemia_Interactive";
		_generalMacro = "acre_test_box";
		scope = 2;
		scopeCurator = 2;
		displayName = "ACRE Test Box 7.5";
		model = "\idi\clients\acre\addons\sys_debug\models\test.p3d";
		icon = "iconObject_1x1";
		accuracy = 1000;
        hiddenSelections[] = {"box"};
        hiddenSelectionsTextures[] = {"#(argb,8,8,3)color(0.290196,0.713725,0.227451,0.75,CO)"};
	};
};