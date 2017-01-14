/*
 * Author: ACRE2Team
 * Returns whether the local player's unit can understand the target unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can understand <BOOLEAN>
 *
 * Example:
 * [unit] call acre_sys_core_fnc_canUnderstand
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _languageId = _unit getVariable [QGVAR(languageId), 0];
private _ret = false;
if (_languageId in ACRE_SPOKEN_LANGUAGES || count GVAR(languages) == 0) then {
    _ret = true;
};
_ret;
