/*
 * Author: ACRE2Team
 * Event handler to monitor inventory changes upon ACRE radios.
 *
 * Arguments:
 * 0: Eventhandler [eventhandler, function handler] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ADDPFH(DFUNC(inventoryMonitorPFH), 0, []);
 *
 * Public: No
 */

#include "script_component.hpp"

if (!isNull INVENTORY_DISPLAY) then {
    TRACE_1("Registering Events", "");
    // Hide the ItemRadio slot
    (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlSetPosition [0,0,0,0];
    (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlCommit 0;

    /* Unused MTT...
    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler["MouseButtonDown", "['uniform',_this] call acre_sys_gui_fnc_handleContextMenu"];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", "['vest',_this] call acre_sys_gui_fnc_handleContextMenu"];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", "['backpack',_this] call acre_sys_gui_fnc_handleContextMenu"];
    */

    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler["LBDblClick", QUOTE([1, "uniform", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([1, "vest", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([1, "backpack", _this] call FUNC(onInventoryAction))];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([0, "uniform", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([0, "vest", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([0, "backpack", _this] call FUNC(onInventoryAction))];

    // Ground
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseDown))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseUp))];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBDblClick", QUOTE([1, "remote", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBSelChanged", QUOTE([0, "remote", _this] call FUNC(onInventoryAction))];

    // Container
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseDown))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(inventoryListMouseUp))];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([1, "remote", _this] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([0, "remote", _this] call FUNC(onInventoryAction))];

    [_this select 1] call CBA_fnc_removePerFrameHandler;
};
