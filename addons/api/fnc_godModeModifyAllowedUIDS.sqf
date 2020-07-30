#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Modifies who has access to God Mode.
 *
 * Arguments:
 * 0: List of player UIDs <ARRAY>
 * 1: Action. 0 for set, 1 for add and 2 for substract <NUMBER> (default: 0)
 *
 * Return Value:
 * Text message sent successfully <BOOL>
 *
 * Example:
 * [[getPlayerUID unit1, 341], 0] call acre_api_fnc_godModeModifyAllowedUIDS
 *
 * Public: Yes
 */

params [
    ["_uids", [], [0, []]],
    ["_action", 0, [0]]
];

if ((_action < GODMODE_ACTION_SET) || {_action > GODMODE_ACTION_SUBSTRACT}) exitWith {
    ERROR_3("Invalid action %1. Valid values are %2 (set), %3 (add) and %4 (substract).",_action,GODMODE_ACTION_SET,GODMODE_ACTION_ADD,GODMODE_ACTION_SUBSTRACT);
    false
};

if !(_uids isEqualType []) then {
    _uids = [_uids];
};

[_uids, _action] call EFUNC(sys_godmode,modifyAllowedUIDS);

true
