/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_position", "_unit"];

if(acre_player != _unit) exitWith {};

TRACE_1("enter", _this);
/*
private _actionValues = _vehicle getVariable QUOTE(GVAR(insideHeadsetActions));

if(!(isNil "_actionValues")) then {
    private _lowerHeadsetAction = _actionValues select 0;
    private _raiseHeadsetAction = _actionValues select 0;

    _vehicle removeAction _lowerHeadsetAction;
    _vehicle removeAction _raiseHeadsetAction;
};
*/
true
