#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles a player when they opt to start using a mounted radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_startUsingMountedRadio
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_radioId"];

private _isRadioAccessible = [_radioId, _unit] call FUNC(isRadioAccessible);
private _isRadioHearable = [_radioId, _unit] call FUNC(isRadioHearable);

if (_isRadioAccessible) then {
    ACRE_ACCESSIBLE_RACK_RADIOS pushBackUnique _radioId;
};

if (_isRadioHearable && {!_isRadioAccessible}) then {
    ACRE_HEARABLE_RACK_RADIOS pushBackUnique _radioId;
};

// Set active radio
ACRE_ACTIVE_RADIO = _radioId;

// Start the rack PFH if not started already. This should only be used for externally accessible rack radios
if (GVAR(rackPFH) == -1) then {
    GVAR(rackPFH) = [DFUNC(rackPFH), 1.1, [_unit, _vehicle]] call CBA_fnc_addPerFrameHandler;
};

// Locally store radio use status for the current position in vehicle
private _varName = [_vehicle, _unit, QGVAR(usedRacks_%1)] call EFUNC(sys_intercom,getStationVariableName);
if (_varName isNotEqualTo "") then {
    private _usedRacks = _vehicle getVariable [_varName, []];
    _usedRacks pushBackUnique _radioId;
    _vehicle setVariable [_varName, _usedRacks];
};

// Update the display
[_vehicle, _unit] call EFUNC(sys_intercom,updateVehicleInfoText);
