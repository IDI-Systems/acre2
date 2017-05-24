/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unique rack ID <STRING>
 *
 * Return Value:
 * Rack removed successfully <BOOL>
 *
 * Example:
 * [cursorTarget, "acre_prc343_id_1"] call acre_api_fnc_removeRackFromVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], "_rackId"];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to remove a rack from an undefined vehicle %1",format ["%1", _vehicle]);
    false
};

if (!([_vehicle] call FUNC(areVehicleRacksInitialized))) exitWith {
    WARNING_1("Vehicle %1 is not initialised. Rack is not being removed.",format ["%1", _vehicle]);
    false
};

if (isDedicated) then {
    // Pick the first player:
    private _player = (allPlayers - entities "HeadlessClient_F") select 0;
    [QGVAR(removeVehicleRacks), [_vehicle, _rackId], _vehicle] call CBA_fnc_targetEvent;
} else {

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) then {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    } else {
        private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

        if (_mountedRadio != "") then {
            [_rackId, _mountedRadio, _vehicle] call FUNC(unmountRackRadio);
        };

        // Delete intercom configuration if any
        if (count ([_rackId] call EFUNC(sys_rack,getWiredIntercoms)) > 0) then {
            private _intercomConfig = _vehicle getVariable [QEGVAR(sys_intercom,rackRxTxConfig), []];
            private _position = 0;
            private _found = false;
            {
                if (_x select 0 == _rackId) exitWith {
                    _found = true;
                    _position = _forEachIndex;
                };
            } forEach _intercomConfig;

            if (_found) then {
                _intercomConfig deleteAt _position;
                _vehicle setVariable [QEGVAR(sys_intercom,rackRxTxConfig), _intercomConfig, true];
            };
        };

        private _racks = _vehicle getVariable [QEGVAR(sys_rack,vehicleRacks), []];
        _racks deleteAt (_racks find _rackId);
        _vehicle setVariable [QEGVAR(sys_rack,vehicleRacks), _racks, true];
    };
};

{
    private _type = typeOf _x;

    if (_type == (toLower _rackId)) exitWith {
        systemChat format ["Deleting %1", _x];
        deleteVehicle _x;
    };
} forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

true

