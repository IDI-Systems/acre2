#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes the specified item from the given unit inventory
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item to be removed <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "ACRE_PRC343"] call acre_sys_core_fnc_removeGear
 *
 * Public: No
 */

params ["_unit", "_item"];

_item = toLower _item;

private _assignedItems = (assignedItems _unit) apply {toLower _x};

if (_item in _assignedItems) then {
    _unit unassignItem _item;
};
_unit removeItem _item;
_unit removeWeapon _item;
