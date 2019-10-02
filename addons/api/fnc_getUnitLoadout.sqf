#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns getUnitLoadout with ACRE base radios
 *
 * Arguments:
 * 0: Unit <OBJECT> (default: acre_player)
 *
 * Return Value:
 * Loadout <ARRAY>
 *
 * Example:
 * _loadout = [unit] call acre_api_fnc_getUnitLoadout;
 *
 * Public: Yes
 */

params [["_unit", acre_player]];

// Loadout
private _loadout = getUnitLoadout _unit;

// Remove "ItemRadioAcreFlagged"
if ((_loadout select 9) select 2 == "ItemRadioAcreFlagged") then {
    (_loadout select 9) set [2, ""];
};

// Set ACRE base classes
private _replaceRadioAcre = {
    params ["_item"];
    // Replace only if string (array can be eg. weapon inside container) and an ACRE radio
    if (!(_item isEqualType []) && {[_item] call FUNC(isRadio)}) then {
        _this set [0, [_item] call FUNC(getBaseRadio)];
    };
};
if !((_loadout select 3) isEqualTo []) then {
    {_x call _replaceRadioAcre} forEach ((_loadout select 3) select 1); // Uniform items
};
if !((_loadout select 4) isEqualTo []) then {
    {_x call _replaceRadioAcre} forEach ((_loadout select 4) select 1); // Vest items
};
if !((_loadout select 5) isEqualTo []) then {
    {_x call _replaceRadioAcre} forEach ((_loadout select 5) select 1); // Backpack items
};

_loadout
