#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes the inventory display by hiding the radio slot and
 * monitoring item movement to hold off radio item checks.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call acre_sys_gui_fnc_initDisplayInventory
 *
 * Public: No
 */

params ["_display"];

// Hide the ItemRadio slot
private _ctrlRadioSlot = _display displayCtrl IDC_FG_RADIO;
_ctrlRadioSlot ctrlSetPosition [0, 0, 0, 0];
_ctrlRadioSlot ctrlCommit 0;

// Ground
private _ctrlGroundItems = _display displayCtrl IDC_FG_GROUND_ITEMS;

_ctrlGroundItems ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown);
}];

_ctrlGroundItems ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];

// Container
private _ctrlContainerItems = _display displayCtrl IDC_FG_CHOSEN_CONTAINER;

_ctrlContainerItems ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown);
}];

_ctrlContainerItems ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];
