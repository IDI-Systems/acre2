#include "script_component.hpp"

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

["vehicle", {
    params ["_player", "_newVehicle"];
    [FUNC(enterVehicle), [_newVehicle, _player]] call CBA_fnc_execNextFrame; // Make sure vehicle info UI is created
}] call CBA_fnc_addPlayerEventHandler;

// Handle the case of starting inside a vehicle. addPlayerEventhandler retrospectively would not work
// when initialising the racks since we have to execute it once radios are being initialised
if (vehicle acre_player != acre_player) then {
    [FUNC(enterVehicle), [vehicle acre_player, acre_player]] call CBA_fnc_execNextFrame; // Make sure vehicle info UI is created
};

["LandVehicle", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Air", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Ship_F", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;

// EH for vehicle racks
[QGVAR(returnRackId), { _this call FUNC(onReturnRackId) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);

// EH for API functions
[QGVAR(initVehicleRacksActions), {
    params ["_vehicle"];

    [_vehicle] call FUNC(initActionVehicle);
}] call CBA_fnc_addEventHandler;

[QGVAR(initVehicleRacks), {
    params ["_vehicle"];

    [_vehicle] call FUNC(initVehicle);

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
    params ["_vehicle", "_rackClassname", "_displayName", "_rackName", "_rackShortName", "_isRadioRemovable", "_allowed", "_disabled", "_mountedRadio", "_components", "_intercoms"];

    [_vehicle, _rackClassname, _displayName, _rackName, _rackShortName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call FUNC(addRack);

    // Give some time for the racks to initialise properly
    [{
        [_this select 0] call FUNC(configureRackIntercom);
    }, [_vehicle], 0.5] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;


[QGVAR(removeVehicleRacks), {
    params ["_vehicle", "_rackId"];

    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent;
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
    private _wiredIntercoms = [_rackId] call FUNC(getWiredIntercoms);
    if !(_wiredIntercoms isEqualTo []) then {
        {
            private _stationName = _x;
            private _rackIntercomConfig = +(_vehicle getVariable [format [QEGVAR(sys_intercom,%1_rack), _stationName], []]);
            {
                if ((_x select 0) isEqualTo _rackId) exitWith {
                    _rackIntercomConfig deleteAt _forEachIndex;
                };
            } forEach _rackIntercomConfig;
            _vehicle setVariable [format [QEGVAR(sys_intercom,%1_rack), _stationName], _rackIntercomConfig, true];
        } forEach (_vehicle getVariable [QEGVAR(sys_intercom,intercomStations), []]);
    };

    private _racks = [_vehicle] call FUNC(getVehicleRacks);
    _racks deleteAt (_racks find _rackId);
    _vehicle setVariable [QGVAR(vehicleRacks), _racks, true];

    {
        private _type = toLower (typeOf _x);

        if (_type == (toLower _rackId)) exitWith {
            deleteVehicle _x;
        };
    } forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);
}] call CBA_fnc_addEventHandler;

[QGVAR(mountRackRadio), {
    params ["_rackId", "_baseRadio"];

    if !([_rackId] call EFUNC(sys_radio,radioExists)) exitWith {
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent;
        false
    };

    if ([_baseRadio] call EFUNC(sys_radio,radioExists)) exitWith {
        [QGVAR(logOnServer), format ["Unique radio ID provided: %1", _baseRadio]] call CBA_fnc_serverEvent;
        false
    };

    if ([_rackId] call FUNC(getMountedRadio) != "") exitWith {
        [QGVAR(logOnServer), format ["Rack ID %1 has already a radio mounted.", _rackId]] call CBA_fnc_serverEvent;
        false
    };

    if !([_rackId] call FUNC(isRadioRemovable)) exitWith {
        [QGVAR(logOnServer), format ["Radio cannot be mounted in rack %1", _rackId]] call CBA_fnc_serverEvent;
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
        ["acre_getRadioId", [_rackObject, _baseRadio, QGVAR(returnRadioId)]] call CBA_fnc_globalEvent;
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(unmountRackRadio), {
    params ["_rackId", "_radioId"];

    if !([_rackId] call EFUNC(sys_radio,radioExists)) exitWith {
        [QGVAR(logOnServer), format ["Non existant rack ID provided: %1", _rackId]] call CBA_fnc_serverEvent;
        false
    };

    if !([_rackId] call FUNC(isRadioRemovable)) exitWith {
        [QGVAR(logOnServer), format ["Radio cannot be dismounted from rack %1", _rackId]] call CBA_fnc_serverEvent;
        false
    };

    if !([_radioId] call EFUNC(sys_radio,radioExists)) exitWith {
        [QGVAR(logOnServer), format ["Non existant radio ID provided: %1", _radioId]] call CBA_fnc_serverEvent;
        false
    };

    private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

    if (_mountedRadio == "") exitWith {
        [QGVAR(logOnServer), format ["Attempting to unmount empty rack: %1", _rackId]] call CBA_fnc_serverEvent;
        false
    };

    if (_mountedRadio != _radioId) exitWith {
        [QGVAR(logOnServer), format ["Trying to dismount %1 from Rack ID %2. However, the mounted radio is %3.", _radioId, _rackId, _mountedRadio]] call CBA_fnc_serverEvent;
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
