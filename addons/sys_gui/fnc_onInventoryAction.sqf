#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whther the an ACRE radio is selected or opened in the inventory.
 *
 * Arguments:
 * 0: Double (1) or single click (0) <NUMBER>
 * 1: Container to look at: uniform, vest or backpack or remote (disabled) <STRING>
 * 2: Array containing the control idc and the additional integer value in the item <ARRAY>
 *
 * Return Value:
 * False <BOOL>
 *
 * Example:
 * [0, "uniform", [101, 0]] call acre_sys_gui_fnc_onInventoryAction
 *
 * Public: No
 */

params ["_typeClick", "_typeIndex", "_vars"];
_vars params ["_idc", "_selectedIndex"];
_idc = ctrlIDC _idc;

TRACE_1("GO", _this);

private _index = lbValue [_idc, _selectedIndex];
private _item = nil;
private _container = nil;

switch _typeIndex do {
    case "uniform": {
        _container = _typeIndex;
        private _itemsArray = uniformItems acre_player;
        _itemsArray append (uniformMagazines acre_player);

        private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
        if (_index < (count _uniqueItems)) then {
            _item = _uniqueItems select _index;
        };
    };
    case "vest": {
        _container = _typeIndex;
        private _itemsArray = vestItems acre_player;
        _itemsArray append (vestMagazines acre_player);

        private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
        if (_index < (count _uniqueItems)) then {
            _item = _uniqueItems select _index;
        };
    };
    case "backpack": {
        _container = _typeIndex;
        private _itemsArray = backpackItems acre_player;
        _itemsArray append (backpackMagazines acre_player);

        private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
        if (_index < (count _uniqueItems)) then {
            _item = _uniqueItems select _index;
        };
    };
    case "remote": {
        // TODO, disabled remote for now
        /*
        _object = uiNamespace getVariable [QGVAR(inventoryObject), nil];
        _container = uiNamespace getVariable [QGVAR(inventoryContainer), nil];
        _itemArray = [];
        _itemArray = _itemArray + ((getWeaponCargo _container) select 0);
        _itemArray = _itemArray + ((getItemCargo _container) select 0);
        _itemArray = _itemArray + ((getMagazineCargo _container) select 0);
        TRACE_2("", _index, _itemArray);
        _item = (_itemArray select _index);
        TRACE_3("Remote object", _item, _object, _container);
        */
    };
};

if (!isNil "_item") then {
    private _ret = [_item] call EFUNC(api,isRadio);
    if (_ret) then {
        private _object = acre_player;
        TRACE_3("Calling handler", _object, _container, _item);
        switch _typeClick do {
            case INV_SELECTION_CHANGED: {
                [_object, _container, _item] call FUNC(onInventoryRadioSelected);
            };
            case INV_DOUBLE_CLICK: {
                [_object, _container, _item] call FUNC(onInventoryRadioDoubleClick);
            };
        };
    };
};

false
