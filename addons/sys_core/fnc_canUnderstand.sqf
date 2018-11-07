#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns whether the local player's unit can understand the target unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can understand <BOOL>
 *
 * Example:
 * [unit] call acre_sys_core_fnc_canUnderstand
 *
 * Public: No
 */

params ["_unit"];

private _languageId = _unit getVariable [QGVAR(languageId), 0];
private _ret = false;
if (_languageId in ACRE_SPOKEN_LANGUAGES || {GVAR(languages) isEqualTo []}) then {
    _ret = true;
};
_ret;
