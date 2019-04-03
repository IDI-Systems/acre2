/*
 * Author: mharis001, courtesy of ACE3 project.
 * Returns list of unique items in a unit's inventory. Items are cached if unit is acre_player.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Items <ARRAY>
 *
 * Example:
 * [acre_player] call acre_sys_core_fnc_uniqueItems
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _fnc_getItems = {
    private _items = (getItemCargo uniformContainer _unit) select 0;
    _items append ((getItemCargo vestContainer _unit) select 0);
    _items append ((getItemCargo backpackContainer _unit) select 0);

    _items arrayIntersect _items
};

// Use cached items list if unit is ACE_player
if (_unit isEqualTo acre_player) then {
    private _items = GVAR(uniqueItemsCache);
    if (isNil "_items") then {
        _items = call _fnc_getItems;
        GVAR(uniqueItemsCache) = _items;
    };
    +_items
} else {
    call _fnc_getItems;
};
