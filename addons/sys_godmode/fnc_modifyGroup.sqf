#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Operate on the target group units.
 *
 * Arguments:
 * 0: Array of units or UIDs or code returning array of units <ARRAY, CODE>
 * 1: Group to effect (0-based index) <NUMBER>
 * 2: Action. 0 for set, 1 for add and 2 for subtract <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[unit1, unit2], 0, 1] call acre_sys_godmode_fnc_modifyGroup
 * [["76561198040512062", "76561198046921073"], 0, 1] call acre_sys_godmode_fnc_modifyGroup
 * [{allUnits select {alive _x}}, 0, 1] call acre_sys_godmode_fnc_modifyGroup
 *
 * Public: No
 */

params ["_units", "_group", "_action"];

switch (_action) do {
    case GODMODE_ACTION_SET: { GVAR(groupPresets) set [_group, _units]; };
    case GODMODE_ACTION_ADD: {
        {
            (GVAR(groupPresets) select _group) pushBackUnique _x;
        } forEach _units;
    };
    case GODMODE_ACTION_SUBTRACT: {
        private _groupArray = GVAR(groupPresets) select _group;
        {
            _groupArray deleteAt (_groupArray find _x);
        } forEach _units;
    };
    default {
        ERROR_4("Invalid action %1. Valid values are %2 (set), %3 (add) and %4 (subtract).",_action,GODMODE_ACTION_SET,GODMODE_ACTION_ADD,GODMODE_ACTION_SUBTRACT);
    };
};
