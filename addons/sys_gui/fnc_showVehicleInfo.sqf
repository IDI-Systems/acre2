#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Show or hide Vehicle Info UI.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call acre_sys_gui_fnc_showVehicleInfo
 *
 * Public: No
 */

params ["_show"];
TRACE_1("show vehicle info",_show);

if (_show) then {
    (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(vehicleInfo), "PLAIN", 0, false];
} else {
    (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
