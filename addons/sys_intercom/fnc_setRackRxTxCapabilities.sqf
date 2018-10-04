#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the configuration (No use, TX Ony, RX only or TX/RX) for the given unit of a rack that is connected to an intercom.
 *
 * Arguments:
 * 0: Unique radio ID mounted on a rack <STRING>
 * 1: Vehicle where the radio rack is <OBJECT>
 * 2: Unit <OBJECT>
 * 3: Functionality: 0 (Not Monitoring), 1 (Receive only), 2 (Transmit only) and 3 (Receive and Transmit) <NUMBER>
 * 4: Unique rack ID <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_vrc110_id_1", vehicle acre_player, acre_player, 2] call acre_sys_intercom_fnc_getRackRxTxCapabilities
 *
 * Public: No
 */

params ["_radioId", "_vehicle", "_unit", "_functionality", ["_rackId", ""]];

private _varName = format ["%1_rack", [_vehicle, _unit] call FUNC(getStationVariableName)];

if (_varName isEqualTo "_rack") exitWith {
    ERROR_2("unit %1 not found in vehicle %2",_unit,_vehicle);
};

private _rackConfiguration = _vehicle getVariable [_varName, []];

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

{
    if (_x select 0 == _rackId) then {
        _x set [1, _functionality];
    };
} forEach _rackConfiguration;

_vehicle setVariable [_varName, _rackConfiguration, true];

[_vehicle, _unit] call FUNC(updateVehicleInfoText);
