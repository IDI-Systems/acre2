#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
DFUNC(inventoryListMouseDown) = {
    if ((_this select 1) == 1) then {
        ACRE_HOLD_OFF_ITEMRADIO_CHECK = true;
        acre_player unassignItem "ItemRadioAcreFlagged";
        acre_player removeItem "ItemRadioAcreFlagged";
    };
};

DFUNC(inventoryListMouseUp) = {
    if ((_this select 1) == 1) then {
        ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
    };
};

//[] call FUNC(initializeVolumeControl);

DVAR(ACRE_CustomVolumeControl) = [displayNull]; //Stores the display of the volume control
GVAR(VolumeControl_Level) = 0; // range of -2 to +2
GVAR(keyBlock) = false;

ADDON = true;
