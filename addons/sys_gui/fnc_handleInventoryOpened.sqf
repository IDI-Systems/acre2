#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handler inventory opened event and adjusts it.
 * Hides radio slot and monitors item movement to hold off radio item check.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_gui_fnc_handleInventoryOpened
 *
 * Public: No
 */

TRACE_1("handleInventoryOpened",isNull INVENTORY_DISPLAY);

// Hide the ItemRadio slot
(INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlSetPosition [0, 0, 0, 0];
(INVENTORY_DISPLAY displayCtrl IDC_RADIOSLOT) ctrlCommit 0;

// Ground
(INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown)
}];
(INVENTORY_DISPLAY displayCtrl IDC_FG_GROUND_ITEMS) ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];

// Container
(INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown)
}];
(INVENTORY_DISPLAY displayCtrl IDC_FG_CHOSEN_CONTAINER) ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];
