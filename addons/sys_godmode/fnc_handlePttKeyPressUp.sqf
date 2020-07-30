#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_godMode_fnc_handlePttKeyPressUp
 *
 * Public: No
 */

if !([getPlayerUID acre_player] call FUNC(accessAllowed)) exitWith { false };

if (GVAR(targetUnits) isEqualTo []) exitWith { false };

[QGVAR(godModeStop), [acre_player], GVAR(targetUnits)] call CBA_fnc_targetEvent;

GVAR(targetUnits) = [];

// Give some time to process
[EFUNC(sys_rpc,callRemoteProcedure), ["stopGodModeSpeaking", ""]] call CBA_fnc_execNextFrame;

true
