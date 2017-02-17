/*
 * Author: ACRE2Team
 * Retrieves a list of unique radio IDs that can be accessed by a player. This includes radios in the inventory that are not being
 * used externally and those radios that are used externally.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Array of unique radio IDs <ARRAY>
 *
 * Example:
 * [] call acre_sys_data_fnc_getPlayerRadioList
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

if (isNull _vehicle) exitWith {[]};

private _itemList = (getItemCargo _vehicle) select 0;
private _itemList = _itemList select {(_x select [0, 4]) == "ACRE" || _x == "ItemRadio" || _x == "ItemRadioAcreFlagged"};
private _radioList = _itemList select {_x call EFUNC(sys_radio,isUniqueRadio)};

_radioList
