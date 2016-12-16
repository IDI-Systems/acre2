#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;

//[] call FUNC(initializeVolumeControl);

DVAR(ACRE_CustomVolumeControl) = nil;
GVAR(VolumeControl_Level) = 0; // range of -2 to +2
GVAR(keyBlock) = false;

ADDON = true;
