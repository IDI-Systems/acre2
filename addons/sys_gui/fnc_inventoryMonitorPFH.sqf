#include "script_component.hpp"
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
 * [acre_sys_gui_inventoryMonitorPFH, 0, []] call CBA_fnc_addPerFrameHandler
 *
 * Public: No
 */


if (!isNull INVENTORY_DISPLAY) then {
    TRACE_1("Registering Events", "");
    // Hide the ItemRadio slot
    (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlSetPosition [0,0,0,0];
    (INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlCommit 0;

    /* Unused MTT...
    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler["MouseButtonDown", QUOTE([ARR_2('uniform',_this)] call FUNC(handleContextMenu))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", QUOTE([ARR_2('vest',_this)] call FUNC(handleContextMenu))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["MouseButtonDown", QUOTE([ARR_2('backpack',_this)] call FUNC(handleContextMenu))];
    */

    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([ARR_3(1, 'uniform', _this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([ARR_3(1, 'vest',_this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([ARR_3(1, 'backpack', _this)] call FUNC(onInventoryAction))];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_UNIFORM_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([ARR_3(0, 'uniform', _this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_VEST_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([ARR_3(0, 'vest', _this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_BACKPACK_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([ARR_3(0, 'backpack', _this)] call FUNC(onInventoryAction))];

    // Ground
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", {call FUNC(inventoryListMouseDown)}];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", {call FUNC(inventoryListMouseUp)}];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBDblClick", QUOTE([ARR_3(1, 'remote', _this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlSetEventHandler ["LBSelChanged", QUOTE([ARR_3(0, 'remote', _this)] call FUNC(onInventoryAction))];

    // Container
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", {call FUNC(inventoryListMouseDown)}];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", {call FUNC(inventoryListMouseUp)}];

    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBDblClick", QUOTE([ARR_3(1, 'remote', _this)] call FUNC(onInventoryAction))];
    (INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlSetEventHandler ["LBSelChanged", QUOTE([ARR_3(0, 'remote', _this)] call FUNC(onInventoryAction))];

    [_this select 1] call CBA_fnc_removePerFrameHandler;
};
