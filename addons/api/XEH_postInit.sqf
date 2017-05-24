#include "script_component.hpp"

[QGVAR(initVehicleRacksActions), {
    params ["_vehicle"];

    [_vehicle] call EFUNC(sys_rack,initActionVehicle);
}] call CBA_fnc_addEventHandler;

[QGVAR(initVehicleRacks), {
    params ["_vehicle"];

    [_vehicle] call EFUNC(sys_rack,initVehicle);

    // Some classes are initialised automatically. Only initialise ACE interaction if the vehicle does not belong to
    // any of these classes
    private _found = false;
    private _automaticInitClasses = ["LandVehicle", "Air", "Ship_F"];
    {
        if (_vehicle isKindOf _x) exitWith {
            _found = true;
        };
    } forEach _automaticInitClasses;

    if (!_found) then {
        [QGVAR(initVehicleRacksActions), [_vehicle]] call CBA_fnc_globalEventJIP;
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(addVehicleRacks), {
    params ["_vehicle", "_componentName", "_displayName", "_isRadioRemovable", "_allowed", "_disabled", "_mountedRadio", "_components", "_intercoms"];

    [_vehicle, _componentName, _displayName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call EFUNC(sys_rack,addRack);

    if (count _intercoms > 0) then {
        _vehicle setVariable [QEGVAR(sys_rack,rackIntercomInitialised), false, true];
    };
}] call CBA_fnc_addEventHandler;


[QGVAR(removeVehicleRacks), {
    params ["_vehicle", "_rackId"];

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    };

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
}] call CBA_fnc_addEventHandler;
