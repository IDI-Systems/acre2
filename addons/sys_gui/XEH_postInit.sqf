#include "script_component.hpp"

if (!hasInterface) exitWith {};

[] call FUNC(enableZeusOverlay);

// TODO - Look into this below.
acre_player addEventHandler ["Take", {call FUNC(handleTake)}];

// Register volume control key handlers
["ACRE2", "VolumeControl", (localize LSTRING(VolumeControl)), FUNC(onVolumeControlKeyPress), FUNC(onVolumeControlKeyPressUp), [15, [false, false, false]]] call cba_fnc_addKeybind;
