#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if a radio being used externally is being returned to the owner or given to another unit.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Unit to be given/returned a radio <OBJECT>
 *
 * Return Value:
 * Radio is returned (true) or given (false) <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_external_fnc_checkReturnGive
 *
 * Public: No
 */

params ["_radioId", "_target"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);

_owner == _target
