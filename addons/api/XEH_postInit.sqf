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
        [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
        [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

        // Trigger event
        [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
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

    {
        private _type = typeOf _x;

        if (_type == (toLower _rackId)) exitWith {
            deleteVehicle _x;
        };
    } forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);
}] call CBA_fnc_addEventHandler;

[QGVAR(mountRackRadio), {
    params ["_rackId", "_baseRadio"];

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    };

    if ([_baseRadio] call EFUNC(sys_radio,radioExists)) exitWith {
        WARNING_1("Unique radio ID provided: %1",_baseRadio);
    };

    if ([_rackId] call FUNC(getMountedRackRadio) != "") exitWith {
        WARNING_1("Rack ID %1 has already a radio mounted.",_rackId);
    };

    if (!([_rackId] call EFUNC(sys_rack,isRadioRemovable))) exitWith {
        WARNING_1("Radio cannot be mounted.",_rackId);
    };

    if (getNumber (configFile >> "CfgWeapons" >> _baseRadio >> "acre_hasUnique") == 1) then {
        private "_rackObject";
        {
            private _type = typeOf _x;
            if (_type == (toLower _rackId)) exitWith {
                _rackObject = _x;
            };
        } forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

        [_rackId, "setState", ["mountedRadio", _baseRadio]] call EFUNC(sys_data,dataEvent);

        //Init the radio
        ["acre_getRadioId", [_rackObject, _baseRadio, QEGVAR(sys_rack,returnRadioId)]] call CBA_fnc_globalEvent;
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(unmountRackRadio), {
    params ["_rackId", "_radioId"];

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    };

    if (!([_rackId] call EFUNC(sys_rack,isRadioRemovable))) exitWith {
        WARNING_1("Radio cannot be dismounted.",_rackId);
    };

    if (!([_radioId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant radio ID provided: %1",_radioId);
    };

    private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

    if (_mountedRadio == "") exitWith {
        WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
    };

    if (_mountedRadio != _radioId) exitWith {
         WARNING_3("Trying to dismount %1 from Rack ID %2. However, the mounted radio is %3.",_radioId,_rackId,_mountedRadio);
         false
    };

    [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    // Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
}] call CBA_fnc_addEventHandler;
