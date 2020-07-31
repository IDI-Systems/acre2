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
 * [1] call acre_sys_godMode_fnc_handlePttKeyPressUp
 *
 * Public: No
 */

params ["_action"];

if !([_action] call FUNC(accessAllowed)) exitWith { false };

// Replace with exitWith after Debug
if (GVAR(targetUnits) isEqualTo []) then { 
    ERROR("Up key action with empty target array");
};

[QGVAR(stopSpeaking), [acre_player], GVAR(targetUnits)] call CBA_fnc_targetEvent;

GVAR(targetUnits) = [];

// Give some time to process
[EFUNC(sys_rpc,callRemoteProcedure), ["stopGodModeSpeaking", ""]] call CBA_fnc_execNextFrame;

true
