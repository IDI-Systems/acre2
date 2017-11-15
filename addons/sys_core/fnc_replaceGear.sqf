/*
 * Author: ACRE2Team
 * Replaces an item in a unit with another one. It is not limited to ACRE 2 related items
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item to be replaced <STRING>
 * 2: Item used as a replacement <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "ACRE_PRC343", "ACRE_PRC152"] call acre_sys_core_fnc_replaceGear
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit", "_itemToReplace", "_itemReplaceWith"];

_itemToReplace = toLower _itemToReplace;
_itemReplaceWith = toLower _itemReplaceWith;

private _uniform = (uniformContainer _unit);
private _uniforCmargo = (itemCargo _uniform) apply {toLower _x};
if (!isNull _uniform && {_itemToReplace in _uniforCmargo}) exitWith {
    _unit removeItem _itemToReplace;
    _uniform addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
};

private _vest = (vestContainer _unit);
private _vestCargo = (itemCargo _vest) apply {toLower _x};
if (!isNull _vest && {_itemToReplace in _vestCargo}) exitWith {
    _unit removeItem _itemToReplace;
    _vest addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
};

private _backpack = (backpackContainer _unit);
private _backpackCargo = (itemCargo _backpack) apply {toLower _x};
if (!isNull _backpack && {_itemToReplace in _backpackCargo}) exitWith {
    _unit removeItem _itemToReplace;
    _backpack addItemCargoGlobal [_itemReplaceWith, 1]; // circumvent limit
};

private _assignedItems = (assignedItems _unit) apply {toLower _x};
if (_itemToReplace in _assignedItems) then {
    _unit unassignItem _itemToReplace;
};

private _weapons = (weapons _unit) apply {toLower _x};
if (_itemToReplace in _weapons) exitWith {
    _unit removeWeapon _itemToReplace;
    _unit addWeapon _itemReplaceWith;
};

_unit removeItem _itemToReplace;
if (_unit canAdd _itemReplaceWith) then {
    _unit addItem _itemReplaceWith;
} else {
    if (!isNull _uniform) exitWith { _uniform addItemCargoGlobal [_itemReplaceWith, 1];};
    if (!isNull _vest) exitWith { _vest addItemCargoGlobal [_itemReplaceWith, 1];};
    if (!isNull _backpack) exitWith { _backpack addItemCargoGlobal [_itemReplaceWith, 1];};
    WARNING_1("Unable to add '%1' to inventory.",_itemReplaceWith);
};
