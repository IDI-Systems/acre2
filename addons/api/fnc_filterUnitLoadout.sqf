#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Filters unitLoadout for ACRE ID classes and replacing them for base classes.
 *
 * Arguments:
 * 0: Loadout <ARRAY or OBJECT or STRING or CONFIG> (default: getUnitLoadout acre_player)
 *
 * Return Value:
 * Loadout <ARRAY>
 *
 * Example:
 * _loadout = [_loadout] call acre_api_fnc_filterUnitLoadout;
 * _loadout = [getUnitLoadout _unit] call acre_api_fnc_filterUnitLoadout;
 * _loadout = [player] call acre_api_fnc_filterUnitLoadout;
 *
 * Public: Yes
 */

params [["_loadout", getUnitLoadout acre_player, [[], objNull, "", configNull]]];

if !(_loadout isEqualType []) then {
    _loadout = getUnitLoadout _loadout;
};

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
