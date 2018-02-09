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
    disableSerialization;

    private _ctrl = ctrlParentControlsGroup (uiNamespace getVariable ["ACRE_VEHICLE_INFO", controlNull]);

    if (!isNull objectParent _player) then {
        _ctrl ctrlShow true;
    } else {
        _ctrl ctrlShow false;
    };
};

// Handle showing the display at the very begining when unit is on foot
[{
    params ["_player"];
    [_player] call FUNC(enterVehicle);
}, [acre_player], 0.1] call CBA_fnc_waitAndExecute;

// Add event handler
["vehicle", {
    params ["_player"];
    [_player] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;
