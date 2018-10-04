#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function called from Extended_InventoryOpened_EventHandlers. Sets the to
 * global namespace the object whose eventhandler is attached to as well as its
 * connected container. Adds a per frame handler to monitor inventory actions upon
 * ACRE radios
 *
 * Arguments:
 * 0: Array containing object and container <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_gui_fnc_openInventory
 *
 * Public: No
 */


uiNamespace setVariable [QGVAR(inventoryObject), _this select 0];
uiNamespace setVariable [QGVAR(inventoryContainer), _this select 1];

ADDPFH(DFUNC(inventoryMonitorPFH), 0, []);
