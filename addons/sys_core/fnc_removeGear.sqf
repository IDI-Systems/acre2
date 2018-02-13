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
#include "script_component.hpp"

params ["_unit", "_item"];

_item = toLower _item;

/*_weapons = weapons _unit;
_uniformItems = uniformItems _unit;
_vestItems = vestItems _unit;
_backpackItems = backpackitems _unit;*/
private _assignedItems = (assignedItems _unit) apply {toLower _x};

if (_item in _assignedItems) then {
    _unit unassignitem _item;
};
_unit removeItem _item;
_unit removeWeapon _item;
// _gearCheck = [_unit] call FUNC(getGear);
// if (_item in _gearCheck) then {

// };
