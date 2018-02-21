/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 * 1: Rack configuration <ARRAY>
 *   0: Base classname of the rack (Without ID) <STRING> (default: "")
 *   1: Rackname - this is diplayed to the user. Ideally short <STRING> (default: "")
 *   2: Rack short name - displayed in GUI information. Max 4 characters <STRING> (default: "")
 *   3: Is mounted radio removable <BOOLEAN> (default: false)
 *   5: Access - Determines who can use the rack <ARRAY> (default: ["inside"])
 *   6: Disabled positions - Blacklist rack use positions <ARRAY> (default: [])
 *   4: Base classname of the mounted radio (Without ID). Empty string for no radio <STRING> (default: "")
 *   7: Components <ARRAY> (default: [])
 *   8: Connected intercoms <ARRAY> (default: [])
 *   9: Speaker position <ARRAY> (default: [0,0,0])
 * 2: Force initialisation <BOOL> (default: false)
 *
 * Return Value:
 * Rack added successfully <BOOL>
 *
 * Example:
 * [cursorTarget, ["ACRE_VRC103", "Upper Dash", "Dash", false, ["external"], [], "ACRE_PRC117F", [], ["intercom_1"], [-1.0, 2.0, 0.0]]] call acre_api_fnc_addRackToVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], "_rackConfiguration", ["_forceInitialisation", false]];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to initialize undefined vehicle %1",_vehicle);
    false
};

private _vehicleInitialized = [_vehicle] call EFUNC(api,areVehicleRacksInitialized);
if (!_vehicleInitialized && !_forceInitialisation) exitWith {
    WARNING_1("Vehicle %1 is not initialised. Rack is not being added.",_vehicle);
    false
};

private _success = true;

if (_forceInitialisation) then {
    if (_vehicleInitialized) then {
        WARNING_1("Vehicle %1 is already initialised but function forces it to initialise again",_vehicle);
    } else {
        TRACE_1("Forcing initialisation of vehicle %1 in order to add a rack",_vehicle);
        _success = [_vehicle] call EFUNC(api,initVehicleRacks);
    };
};

if (!_success) exitWith {
    WARNING_1("Vehicle %1 failed to initialise",_vehicle);
};

if (count _rackConfiguration != 9) exitWith {
    WARNING_1("Invalid number of entries in the rack configuration array for vehicle: %1",_vehicle);
    false
};

_rackConfiguration params [["_rackClassname", ""], ["_rackName", ""], ["_rackShortName", ""], ["_isRadioRemovable", false], ["_allowed", ["inside"]], ["_disabled", []], ["_mountedRadio", ""], ["_defaultComponents", []], ["_intercoms", []], ["_speakerPosition", [0, 0, 0]]];

if (_rackClassname isEqualTo "") exitWith {
    WARNING_1("No rack specified for vehicle %1",_vehicle);
    false
};

if (_rackName isEqualTo "") exitWith {
    WARNING_1("No valid rack specified for vehicle %1",_vehicle);
    false
};

if (_rackShortName isEqualTo "") exitWith {
    WARNING_1("No valid rack short name specified for vehicle %1 and rack %2",_vehicle,_rackName);
    false
};

private _allowed = [_vehicle, _allowed] call EFUNC(sys_core,processVehicleSystemAccessArray);
private _disabled = [_vehicle, _disabled] call EFUNC(sys_core,processVehicleSystemAccessArray);
_intercoms = _intercoms apply {toLower _x};

// A player must do the action of adding a rack
private _player = objNull;

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[QEGVAR(sys_rack,addVehicleRacks), [_vehicle, _rackClassname, _rackName, _rackShortName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _defaultComponents, _intercoms, _speakerPosition], _player] call CBA_fnc_targetEvent;

true
