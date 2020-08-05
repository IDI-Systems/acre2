#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sends a text message to a specific group preset (only alive units).
 *
 * Arguments:
 * 0: Text message <STRING>
 * 1: Group index (0-based index) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["text message", 0] call acre_sys_godmode_fnc_sendTextMessage
 *
 * Public: No
 */

params ["_text", "_group"];

if !([_group] call FUNC(accessAllowed)) exitWith { false };

private _targetUnits = (GVAR(groupPresets) select _group) select {alive _x};

[QGVAR(showText), [_text], _targetUnits] call CBA_fnc_targetEvent;

true
