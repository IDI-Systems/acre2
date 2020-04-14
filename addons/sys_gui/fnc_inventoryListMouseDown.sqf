#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handle mouse down on inventory display, holding off "ItemRadio" check in case of inventory manipulation.
 * Primary idea is to handle right-click movement of radios from ground or container into player's inventory.
 *
 * Arguments:
 * 0: Display Control <CONTROL>
 * 1: Button <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * display ctrlAddEventHandler ["MouseButtonDown", {call acre_sys_gui_fnc_inventoryListMouseDown}];
 *
 * Public: No
 */

params ["", "_button"];

// Right Mouse Button
if (_button == 1) then {
    ACRE_HOLD_OFF_ITEMRADIO_CHECK = true;

    // Remove existing ItemRadioAcreFlagged to make space for "ItemRadio" in case player is picking that up
    // Will RPT log: 'Inventory item with given name: [ItemRadioAcreFlagged] not found'
    // however that should not happen often
    acre_player unassignItem "ItemRadioAcreFlagged";
    acre_player removeItem "ItemRadioAcreFlagged";
    LOG("inventoryListMouseDown");
};
