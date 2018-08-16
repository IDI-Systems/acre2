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
 * ["acre_prc152_id_1", 0.8] call acre_sys_intercom_fnc_getRadioVolume
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_volume", ["_vehicle", objNull], ["_rackId", ""]];

if (!(_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) && {!(_radioId in ACRE_HEARABLE_RACK_RADIOS)}) exitWith {_volume};

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

if (_rackId != "") then {
    if (isNull _vehicle) then {
        _vehicle = [_rackId] call EFUNC(sys_rack,getVehicleFromRack):
    };

    private _accentConfig = _vehicle getVariable [QGVAR(accent)];
    private _connectedIntercoms = [_rackId] call EFUNC(sys_rack,getWiredIntercoms);

    if !(_connectedIntercoms isEqualTo []) then {
        private _intercomVolume = 0;
        private _connected = false;

        {
            params ["_intercomName", "_intercomInUse"];

            if ( (_intercomName in _connectedIntercoms ) && {[_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)}) then {
                _connected = true;
                private _tempVolume = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
                if (_accentConfig # _forEachIndex && {_intercomInUse}) exitWith {
                    _tempVolume = _tempVolume * 0.8; // Reduce volume by 20% if intercom is active and there is an incomming radio transmission
                };

                if (_vol > _intercomVolume) then {
                    _intercomVolume = _vol;
                };
            };
        } forEach GVAR(intercomUse);
    };
};

_volume
