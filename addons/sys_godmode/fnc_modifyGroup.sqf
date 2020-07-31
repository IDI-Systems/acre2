#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Operate on the target group units.
 *
 * Arguments:
 * 0: Array of units <ARRAY>
 * 1: Group to effect (0-based index) <NUMBER>
 * 2: Action. 0 for set, 1 for add and 2 for subtract <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[unit1, unit2], 0, 1] call acre_sys_godMode_fnc_modifyGroup
 *
 * Public: No
 */

params ["_units", "_group", "_action"];

switch (_action) do {
    case GODMODE_ACTION_SET: { GVAR(targetUnits) set [_group, _units]; };
    case GODMODE_ACTION_ADD: {
        {
            (GVAR(targetUnits) select _group) pushBackUnique _x;
        } forEach _units;
    };    
    case GODMODE_ACTION_SUBTRACT: {
        private _groupArray = GVAR(targetUnits) select _group;
        {
            _groupArray deleteAt (_groupArray find _x);
        } forEach _units;
    };
    default {
        ERROR_3("Invalid action %1. Valid values are %2 (set), %3 (add) and %4 (subtract).",_action,GODMODE_ACTION_SET,GODMODE_ACTION_ADD,GODMODE_ACTION_SUBTRACT);
    };
};
