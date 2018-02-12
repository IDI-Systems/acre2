/*
 * Author: ACRE2Team
 * Updates the text on the Vehicle Info UI.
 *
 * Arguments:
 * 0: Structured text to show. <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE"] call acre_sys_gui_fnc_updateVehicleInfo
 *
 * Public: No
 */

params ["_str"];

(uiNamespace getVariable ["ACRE_VehicleInfo", controlNull]) ctrlSetStructuredText parseText _str;
