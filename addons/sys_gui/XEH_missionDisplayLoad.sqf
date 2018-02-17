#include "script_component.hpp"

params ["_display"];

// Init the volume control
GVAR(MWheel) = _display displayAddEventHandler ["MouseZChanged", {call FUNC(onVolumeControlAdjust)}];
