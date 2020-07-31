#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Operate on the allowed UIDs that have access to God Mode.
 *
 * Arguments:
 * 0: List of player UIDs <ARRAY>
 * 1: Action. 0 for set, 1 for add and 2 for subtract <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[getPlayerUID unit1, 789], 0] call acre_sys_godmode_fnc_modifyAllowedUIDS
 *
 * Public: No
 */

params ["_uids", "_action"];

switch (_action) do {
    case GODMODE_ACTION_SET: { missionNamespace setVariable[QGVAR(allowedUIDS), _uids, true]; };
    case GODMODE_ACTION_ADD: {
        private _allowedUIDS = missionNamespace getVariable[QGVAR(allowedUIDS), []];
        {
            _allowedUIDS pushBackUnique _x;
        } forEach _uids;
        missionNamespace setVariable[QGVAR(allowedUIDS), _allowedUIDS, true];
    };    
    case GODMODE_ACTION_SUBTRACT: {
        private _allowedUIDS = missionNamespace getVariable[QGVAR(allowedUIDS), []];
        {
            _allowedUIDS deleteAt (_allowedUIDS find _x);
        } forEach _uids;
        missionNamespace setVariable[QGVAR(allowedUIDS), _allowedUIDS, true];
    };
    default {
        ERROR_3("Invalid action %1. Valid values are %2 (set), %3 (add) and %4 (subtract).",_action,GODMODE_ACTION_SET,GODMODE_ACTION_ADD,GODMODE_ACTION_SUBTRACT);
    };
};
