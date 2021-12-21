#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns given group's current targets.
 *
 * Arguments:
 * 1: Group (0-based index or -1 for current channel) <NUMBER> (default: 0)
 *
 * Return Value:
 * Group targets <ARRAY>
 *
 * Example:
 * [0] call acre_api_fnc_godModeGetGroupTargets
 *
 * Public: Yes
 */

params [["_group", 0, [0]]];

private _targets = [];

if ((_group < -1) || {_group >= GODMODE_NUMBER_OF_GROUPS}) exitWith {
    ERROR_2("Invalid group ID. Group ID must be between -1 and %1, but %2 is entered.",GODMODE_NUMBER_OF_GROUPS-1,_group);
    []
};

if (_group < -1) then {
    _targets = [] call EFUNC(sys_godmode,getUnitsBIChannel);
} else {
    _targets = EGVAR(sys_godmode,groupPresets) select _group;
};

if (_targets isEqualType {}) then {
    _targets = call _targets;
};

_targets
