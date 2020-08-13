#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets a visible name for the given God Mode group.
 *
 * Arguments:
 * 0: Name <STRING>
 * 1: Group to effect (0-based index) <NUMBER> (default: 0)
 *
 * Return Value:
 * Group name set successfully <BOOL>
 *
 * Example:
 * ["Admin", 0] call acre_api_fnc_godModeNameGroup
 *
 * Public: Yes
 */

params [
    ["_name", "", [""]],
    ["_group", 0, [0]]
];

if ((_group < 0) || {_group >= GODMODE_NUMBER_OF_GROUPS}) exitWith {
    ERROR_1("Invalid group ID. Group ID must be between 0 and %1, but %2 is entered.",GODMODE_NUMBER_OF_GROUPS-1,_group);
    false
};

if (_name == "") exitWith {
    ERROR_1("Invalid name for group ID %1. Name must not be empty!",_group);
    false
};

[_name, _group] call EFUNC(sys_godmode,nameGroup);

true
