#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * 0: Action <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_godmode_fnc_handlePttKeyPress
 *
 * Public: No
 */

params ["_action"];

if !([_action] call FUNC(accessAllowed)) exitWith { false };

switch (_action) do {
    case GODMODE_CURRENTCHANNEL: { GVAR(targetUnits) = []  call FUNC(getUnitsBIChannel); };
    case GODMODE_GROUP1: { GVAR(targetUnits) = (GVAR(groupPresets) select 0) select {alive _x}; };
    case GODMODE_GROUP2: { GVAR(targetUnits) = (GVAR(groupPresets) select 1) select {alive _x}; };
    case GODMODE_GROUP3: { GVAR(targetUnits) = (GVAR(groupPresets) select 2) select {alive _x}; };
    default { ERROR_1("Invalid action %1",_action); };
};

// Enable after debug phase
//if (GVAR(targetUnits) isEqualTo []) exitWith {
//    WARNING("No units in the selected group.");
//    false
//};

[QGVAR(startSpeaking), [acre_player], GVAR(targetUnits)] call CBA_fnc_targetEvent;

// Give some time to process
[EFUNC(sys_rpc,callRemoteProcedure), ["startGodModeSpeaking", ""]] call CBA_fnc_execNextFrame;

true
