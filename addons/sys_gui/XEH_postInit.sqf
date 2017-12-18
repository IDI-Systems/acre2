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

["vehicle", {
    params ["_player"];
    disableSerialization;

    private _ctrl = ctrlParentControlsGroup (uiNamespace getVariable ["ACRE_VEH_INFO", controlNull]);

    if (!isNull objectParent _player) then {
        _ctrl ctrlShow true;
    } else {
        _ctrl ctrlShow false;
    };
}] call CBA_fnc_addPlayerEventHandler;