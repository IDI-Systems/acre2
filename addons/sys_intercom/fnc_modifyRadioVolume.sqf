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
#include "script_component.hpp"

params ["_radioId", "_volume", ["_vehicle", objNull], ["_rackId", ""]];

if (!(_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) && {!(_radioId in ACRE_HEARABLE_RACK_RADIOS)}) exitWith {_volume};

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

if (_rackId == "") exitWith {_volume};


if (isNull _vehicle) then {
    _vehicle = [_rackId] call EFUNC(sys_rack,getVehicleFromRack);
};

private _accentConfig = _vehicle getVariable [QGVAR(accent)];
private _connectedIntercoms = [_rackId] call EFUNC(sys_rack,getWiredIntercoms);

if (_connectedIntercoms isEqualTo []) exitWith {_volume};

private _modifiedVolume = 0;
{
    params ["_intercomName", "_intercomInUse"];

    if ( (_intercomName in _connectedIntercoms ) && {[_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)}) then {
        private _intercomVolume = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
        private _tempVolume = 0;

        if (_intercomInUse) then {
            if (_accentConfig # _forEachIndex) then {
                _tempVolume = _intercomVolume * 0.8; // Reduce volume by 20% if intercom is active and there is an incomming radio transmission
            } else {
                // Set the radio volume to the intercom volume
                _tempVolume = _volume;
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
