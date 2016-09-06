/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"
//TRACE_1("ENTER", _this);

#define INVENTORY_DISPLAY (findDisplay 602)

#define IDC_FG_VEST_CONTAINER 638
#define IDC_FG_UNIFORM_CONTAINER 633
#define IDC_FG_BACKPACK_CONTAINER 619
#define IDC_FG_GROUND_ITEMS       632
#define IDC_FG_CHOSEN_CONTAINER  640

#define IDC_RADIOSLOT 6214

#define INV_SELECTION_CHANGED 0
#define INV_DOUBLE_CLICK 1

DFUNC(uniqueArray) = {
    params[["_inArray",[]]];

    (_inArray arrayIntersect _inArray)
};

DFUNC(onInventoryAction) = {
    private["_container" , "_item"];
    params["_typeClick", "_typeIndex", "_vars"];
    _vars params ["_idc", "_selectedIndex"];
    _idc = ctrlIDC (_idc);


    _container = nil;

    TRACE_1("GO", _this);

    private _index = lbValue [_idc, _selectedIndex];
    _item = nil;
    switch _typeIndex do {
        case 'uniform': {
            _container = _typeIndex;
            private _itemsArray = (uniformItems acre_player) + (uniformMagazines acre_player);
            private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
            if(_index < (count _uniqueItems) ) then {
                _item = _uniqueItems select _index;
            };
        };
        case 'vest': {
            _container = _typeIndex;
            private _itemsArray = (vestItems acre_player) + (vestMagazines acre_player);
            private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
            if(_index < (count _uniqueItems) ) then {
                _item = _uniqueItems select _index;
            };
        };
        case 'backpack': {
            _container = _typeIndex;
            private _itemsArray = (backpackItems acre_player) + (backpackMagazines acre_player);
            private _uniqueItems = [_itemsArray] call FUNC(uniqueArray);
            if(_index < (count _uniqueItems) ) then {
                _item = _uniqueItems select _index;
            };
        };
        case 'remote': {
            // TODO, disabled remote for now
            /*
            _object = uiNamespace getVariable[QUOTE(GVAR(inventoryObject)), nil];
            _container = uiNamespace getVariable[QUOTE(GVAR(inventoryContainer)), nil];
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

    if(!isNil "_item") then {
        _ret = [_item] call acre_api_fnc_isRadio;
        if(_ret) then {
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
};

DFUNC(handleContextMenu) = {
    private["_cargs", "_location"];
    TRACE_1("enter", _this);

    /*
    _location = _this select 0;
    _cargs = _this select 1;
    _coords = [_this select 2, _this select 3];

    if(_cargs select 4) then {
        // SHOW THE MPPT SELECTION DIALOG HERE

    };
    */
};


uiNamespace setVariable[QUOTE(GVAR(inventoryObject)), (_this select 0)];
uiNamespace setVariable[QUOTE(GVAR(inventoryContainer)), (_this select 1)];
DFUNC(inventoryMonitorPFH) = {
    if(!isNull INVENTORY_DISPLAY) then {
        TRACE_1("Registering Events", "");
        // Hide the ItemRadio slot
        (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlSetPosition [0,0,0,0];
        (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlCommit 0;

        /* Unused MTT...
        (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler["MouseButtonDown", "['uniform',_this] call acre_sys_gui_fnc_handleContextMenu"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", "['vest',_this] call acre_sys_gui_fnc_handleContextMenu"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", "['backpack',_this] call acre_sys_gui_fnc_handleContextMenu"];
        */

        (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler["LBDblClick", "[1, 'uniform',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBDblClick", "[1, 'vest',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBDblClick", "[1, 'backpack',_this] call acre_sys_gui_fnc_onInventoryAction"];

        (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler ["LBSelChanged", "[0, 'uniform',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBSelChanged", "[0, 'vest',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBSelChanged", "[0, 'backpack',_this] call acre_sys_gui_fnc_onInventoryAction"];

        // Ground
        (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseDown))];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseUp))];

        (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBDblClick", "[1, 'remote',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBSelChanged", "[0, 'remote',_this] call acre_sys_gui_fnc_onInventoryAction"];
        // Container
        (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseDown))];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseUp))];

        (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBDblClick", "[1, 'remote',_this] call acre_sys_gui_fnc_onInventoryAction"];
        (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBSelChanged", "[0, 'remote',_this] call acre_sys_gui_fnc_onInventoryAction"];

        [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
    };
};
ADDPFH(DFUNC(inventoryMonitorPFH), 0, []);
