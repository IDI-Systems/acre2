/*
 * Author: ACRE2Team
 * Check if a radio being used externally is being returned to the owner or given to another unit
 *
 * Arguments:
 * 1: Unique radio ID <STRING>
 * 0: Unit to be given/returned a radio <OBJECT>
 *
 * Return Value:
 * Radio is returned (true) or given (false) <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_fnc_externalRadioReturnGive
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_target"];

private _owner = [_radioId] call EFUNC(sys_external,getExternalRadioOwner);

player sideChat format ["Check Ret owner %1, target %2", _owner, _target];

if (isNil "_owner") exitWith {true};
if (_owner == _target) exitWith {true};

false
