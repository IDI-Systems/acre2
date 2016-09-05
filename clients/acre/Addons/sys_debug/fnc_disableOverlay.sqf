//fnc_disableOverlay.sqf
#include "script_component.hpp"

private ["_x"];
if(ACRE_OVERLAY_ENABLED) then {
	ACRE_OVERLAY_ENABLED = false;
	{
		{
			ctrlDelete _x;
		} forEach _x;
	} forEach ACRE_DEBUG_OVERLAYS;
	ACRE_DEBUG_OVERLAYS = [];
};
ACRE_OVERLAY_ENABLED = false;
