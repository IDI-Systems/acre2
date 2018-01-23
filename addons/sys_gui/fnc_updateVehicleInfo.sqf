/*
 * Author: ACRE2Team
 * Updates the text on the ACRE vehicle INFO Bar.
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

disableSerialization;
params["_str"];

private _ctrl = (uiNamespace getVariable ["ACRE_VEHICLE_INFO", controlNull]);

_ctrl ctrlSetStructuredText parseText _str;
