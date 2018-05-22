/*
 * Author: ACRE2Team
 * Gets the preset name used for initialising the vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (Default: objNull)
 *
 * Return Value:
 * Preset name. Empty string if not defined <STRING> 
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_getVehicleRacksPreset
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_presetName", ""]];

if (isNull _vehicle) exitWith {
    ERROR("Vehicle is null");
    ""
};

_vehicle getVariable [QEGVAR(sys_rack,vehicleRacksPreset), ""]
