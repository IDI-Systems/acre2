#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the local radio volume affected by intercom.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Volume <NUMBER>
 * 2: Vehicle <OBJECT> (default: objNull)
 * 3: Rack ID <STRING> (default: "")
 *
 * Return Value:
 * Radio volume affected by intercom <NUMBER>
 *
 * Example:
 * ["acre_prc152_id_1", 0.8] call acre_sys_intercom_fnc_modifyRadioVolume
 *
 * Public: No
 */

params ["_radioId", "_volume", ["_vehicle", objNull], ["_rackId", ""]];

if (!(_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) && {!(_radioId in ACRE_HEARABLE_RACK_RADIOS)}) exitWith {_volume};

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

if (_rackId == "") exitWith {_volume};

if (isNull _vehicle) then {
    _vehicle = [_rackId] call EFUNC(sys_rack,getVehicleFromRack);
};

private _accentConfig = _vehicle getVariable [QGVAR(accent), [false]];
private _connectedIntercoms = [_rackId] call EFUNC(sys_rack,getWiredIntercoms);
if (_connectedIntercoms isEqualTo []) exitWith {_volume};

private _modifiedVolume = 0;
{
    _x params ["_intercomName", "_intercomInUse"];
    private _connected = ([_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)) > 0;
    if ((_intercomName in _connectedIntercoms) && {_connected}) then {
        private _intercomVolume = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
        private _tempVolume = _intercomVolume;
        if (_intercomInUse && {_accentConfig select _forEachIndex}) then {
            _tempVolume = _intercomVolume * INTERCOM_ACCENT_VOLUME_FACTOR; // Reduce volume by 20% if intercom is active and there is an incomming radio transmission
            if (_tempVolume < MINIMUM_INTERCOM_ACCENT_VOLUME) then {
                _tempVolume = MINIMUM_INTERCOM_ACCENT_VOLUME;
            };
        };

        // Always return the highest intercome outcome
        if (_tempVolume > _modifiedVolume) then {
            _modifiedVolume = _tempVolume;
        };
    };
} forEach GVAR(intercomUse);

if (_modifiedVolume > 0) exitWith {_modifiedVolume};

_volume
