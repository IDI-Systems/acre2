#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds the specified item to a unit.
 * The item can be added to a specific container (uniform, vest or backpack) or wherever can be added.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item to be added <STRING>
 * 2: Location where the item will be added: vest, uniform or backpack <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "ACRE_PRC343"] call acre_sys_core_fnc_addGear
 * [player, "ACRE_PRC343", "uniform"] call acre_sys_core_fnc_addGear
 *
 * Public: No
 */

params ["_unit", "_item", ["_gearContainer",""]];

if (_gearContainer != "") then {
    switch _gearContainer do {
        case 'vest': {
            _unit addItemToVest _item;
        };
        case 'uniform': {
            _unit addItemToUniform _item;
        };
        case 'backpack': {
            _unit addItemToBackpack _item;
        };
    };
} else {
    if (_unit canAdd _item) then {
        _unit addItem _item;
    } else {
        // Attempt to force add Item.
        private _uniform = uniformContainer _unit;
        if (!isNull _uniform) exitWith { _uniform addItemCargoGlobal [_item, 1];};
        private _vest = vestContainer _unit;
        if (!isNull _vest) exitWith { _vest addItemCargoGlobal [_item, 1];};
        private _backpack = backpackContainer _unit;
        if (!isNull _backpack) exitWith { _backpack addItemCargoGlobal [_item, 1];};
    };
};
