#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles picking up a vanilla radio item.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Container <OBJECT>
 * 2: Item Class Name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, container, "type"] call acre_sys_gui_fnc_handleTake
 *
 * Public: No
 */

params ["_unit", "_container", "_itemType"];

private _simulationType = getText (configFile >> "CfgWeapons" >> _itemType >> "simulation");

if (_simulationType == "ItemRadio") then {
    // _allowedSlots = getArray(configFile >> "CfgWeapons" >> _itemType >> "itemInfo" >> "allowedSlots");
    // _unit sideChat format["this: %1", _unit canAdd _itemType];
    if (!(_unit canAdd _itemType)) then {
        // _unit sideChat format["items: %1", items _unit];
        if (!(_itemType in (items _unit))) then {
            _container addItemCargoGlobal [_itemType, 1];
        };
    };
    // _unit assignItem "ItemRadioAcreFlagged";
};
