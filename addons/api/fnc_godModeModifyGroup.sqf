#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Modifies who can hear a message from God Mode.
 *
 * Arguments:
 * 0: Unit or UID or array of either <OJECT, ARRAY> (default: [])
 * 1: Group to effect (0-based index) <NUMBER> (default: 0)
 * 2: Action. 0 for set, 1 for add and 2 for subtract <NUMBER> (default: 0)
 *
 * Return Value:
 * Text message sent successfully <BOOL>
 *
 * Example:
 * [[unit1, unit2], 0, 1] call acre_api_fnc_godModeModifyGroup
 * [["76561198040512062", "76561198046921073"], 0, 1] call acre_api_fnc_godModeModifyGroup
 *
 * Public: Yes
 */

params [
    ["_units", [], [objNull, "", []]],
    ["_group", 0, [0]],
    ["_action", 0, [0]]
];

if ((_group < 0) || {_group >= GODMODE_NUMBER_OF_GROUPS}) exitWith {
    ERROR_1("Invalid group ID. Group ID must be between 0 and %1, but %2 is entered.",GODMODE_NUMBER_OF_GROUPS-1,_group);
    false
};

if ((_action < GODMODE_ACTION_SET) || {_action > GODMODE_ACTION_SUBTRACT}) exitWith {
    ERROR_3("Invalid action %1. Valid values are %2 (set), %3 (add) and %4 (subtract).",_action,GODMODE_ACTION_SET,GODMODE_ACTION_ADD,GODMODE_ACTION_SUBTRACT);
    false
};

if !(_units isEqualType []) then {
    _units = [_units];
};

[_units, _group, _action] call EFUNC(sys_godmode,modifyGroup);

true
