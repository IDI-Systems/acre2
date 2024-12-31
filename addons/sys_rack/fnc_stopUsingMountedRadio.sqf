#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles a player when they opt to stop using a mounted radio. Safely handles off usage of the radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, "ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_stopUsingMountedRadio
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_radioId"];

if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) then {
    ACRE_ACCESSIBLE_RACK_RADIOS deleteAt (ACRE_ACCESSIBLE_RACK_RADIOS find _radioId);
} else {
    ACRE_HEARABLE_RACK_RADIOS deleteAt (ACRE_HEARABLE_RACK_RADIOS find _radioId);
};

[_radioId] call EFUNC(sys_radio,stopUsingRadio);

// Remove radio use status for the current position in vehicle
private _varName = [_vehicle, _unit, QGVAR(usedRacks_%1)] call EFUNC(sys_intercom,getStationVariableName);
if (_varName isNotEqualTo "") then {
    private _usedRacks = _vehicle getVariable [_varName, []];
    _usedRacks deleteAt (_usedRacks find _radioId);
    _vehicle setVariable [_varName, _usedRacks];
};

// Update the display
[_vehicle, _unit] call EFUNC(sys_intercom,updateVehicleInfoText);
