/*
 * Author: ACRE2Team
 * Initialize volume control and vehicle info UI.
 *
 * Arguments:
 * Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_missionDisplayLoad
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_display"];

// Init the volume control
GVAR(MWheel) = _display displayAddEventHandler ["MouseZChanged", {call FUNC(onVolumeControlAdjust)}];

// Create VehicleInfoGroup
private _vehInfoGroup = _display ctrlCreate [QGVAR(VehicleInfo), -1];
