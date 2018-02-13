#include "script_component.hpp"

if (!hasInterface) exitWith {};

[] call FUNC(enableZeusOverlay);

// TODO - Look into this below.
acre_player addEventHandler ["Take", {call FUNC(handleTake)}];

// Register volume control key handlers
["ACRE2", "VolumeControl", localize LSTRING(VolumeControl),
    FUNC(onVolumeControlKeyPress),
    FUNC(onVolumeControlKeyPressUp),
[15, [false, false, false]], true] call CBA_fnc_addKeybind;

["unit", FUNC(onVolumeControlKeyPressUp)] call CBA_fnc_addPlayerEventHandler;

DFUNC(enterVehicle) = {
    params ["_player"];

    if (!isNull objectParent _player) then {
        // Open vehicle info display
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(vehicleInfo), "PLAIN", 0, false];
    } else {
        // Close vehicle info display
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    };
};

// Show display when entering vehicle
["vehicle", {
    params ["_player"];
    [_player] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;

// Show display at the very begining
[acre_player] call FUNC(enterVehicle);
