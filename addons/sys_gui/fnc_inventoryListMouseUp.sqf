#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handle mouse up on inventory display, restarting "ItemRadio" check after possible inventory manipulation.
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
 * display ctrlAddEventHandler ["MouseButtonDown", {call acre_sys_gui_fnc_inventoryListMouseUp}];
 *
 * Public: No
 */

params ["", "_button"];

// Right Mouse Button
if (_button == 1) then {
    LOG("inventoryListMouseUp");
    ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
};
