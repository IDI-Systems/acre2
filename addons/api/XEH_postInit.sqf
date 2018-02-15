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

    // Give some time for the racks to initialise properly
    [{
        [_this select 0] call EFUNC(sys_rack,configureRackIntercom);
    }, [_vehicle], 0.5] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;


[QGVAR(removeVehicleRacks), {
    params ["_vehicle", "_rackId"];

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

    if (_mountedRadio != "") then {
        [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
        [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

        // Trigger event
        [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
    };

    // Delete intercom configuration if any
    private _wiredIntercoms = [_rackId] call EFUNC(sys_rack,getWiredIntercoms);
    if !(_wiredIntercoms isEqualTo []) then {
        {
            private _stationName = _x;
            private _rackIntercomConfig = +(_vehicle getVariable [format [QEGVAR(sys_intercom,%1_rack), _stationName], []]);
            {
                if ((_x select 0) isEqualTo _rackId) exitWith {
                    _rackIntercomConfig deleteAt _forEachIndex;
                }
            } forEach _rackIntercomConfig;

            _vehicle setVariable [format [QEGVAR(sys_intercom,%1_rack), _stationName], _rackIntercomConfig, true]);
        } forEach (_vehicle getVariable [QEGVAR(sys_intercom,intercomStations), []]);
    };

    private _racks = [_vehicle] call EFUNC(sys_rack,getVehicleFromRack);
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
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    if ([_baseRadio] call EFUNC(sys_radio,radioExists)) exitWith {
        [QGVAR(logOnServer), format ["Unique radio ID provided: %1", _baseRadio]] call CBA_fnc_serverEvent);
        false
    };

    if ([_rackId] call FUNC(getMountedRackRadio) != "") exitWith {
        [QGVAR(logOnServer), format ["Rack ID %1 has already a radio mounted.", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    if (!([_rackId] call EFUNC(sys_rack,isRadioRemovable))) exitWith {
        [QGVAR(logOnServer), format ["Radio cannot be mounted in rack %1", _rackId]] call CBA_fnc_serverEvent);
        false
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
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    if (!([_rackId] call EFUNC(sys_rack,isRadioRemovable))) exitWith {
        [QGVAR(logOnServer), format ["Radio cannot be dismounted from rack %1", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    if (!([_radioId] call EFUNC(sys_radio,radioExists))) exitWith {
        [QGVAR(logOnServer), format ["Non existant radio ID provided: %1", _radioId]] call CBA_fnc_serverEvent);
        false
    };

    private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

    if (_mountedRadio == "") exitWith {
        [QGVAR(logOnServer), format ["Attempting to unmount empty rack: %1", _rackId]] call CBA_fnc_serverEvent);
        false
    };

    if (_mountedRadio != _radioId) exitWith {
        [QGVAR(logOnServer), format ["Trying to dismount %1 from Rack ID %2. However, the mounted radio is %3.", _radioId, _rackId, _mountedRadiod]] call CBA_fnc_serverEvent);
        false
    };

    [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    // Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(logOnServer), {
    params ["_text"];

    WARNING(_text);
}] call CBA_fnc_addEventHandler;
