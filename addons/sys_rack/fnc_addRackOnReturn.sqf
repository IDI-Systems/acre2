#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles setting up the rack once a unique ID has been returned by the server
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Rack ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle2,"ACRE_VRC110_ID_1"] call acre_sys_rack_fnc_addRackOnReturn
 *
 * Public: No
 */

params ["_vehicle", "_rackId"];

private _rack = createVehicle [_rackId, [-1000,-1000,-1000], [], 0, "CAN_COLLIDE"];
_rack enableSimulation false;
if (isNull _rack) exitWith {
    WARNING_2("Error creating rack '%2' for vehicle %1",str _vehicle,_rackId);
};

private _vehicleRacks = _vehicle getVariable [QGVAR(vehicleRacks), []];
_vehicleRacks pushBackUnique _rackId;
_vehicle setVariable [QGVAR(vehicleRacks), _vehicleRacks, true];
_rack setVariable [QGVAR(rackVehicle), _vehicle, true];

private _queue = _vehicle getVariable [QGVAR(queue),[]];
private _baseRackName = configName (configFile >> "CfgAcreComponents" >> (getText (configFile >> "CfgVehicles" >> _rackId >> "acre_baseClass")));
private _handled = false;
private _idx = -1;
{
    if (_handled) exitWith {};
    if (_baseRackName == _x select 0) exitWith {

        // Initalize the Rack Component
        _x pushBack _vehicle;
        [_rackId, "initializeComponent", _x] call EFUNC(sys_data,dataEvent);

        private _mountedRadio = _x select 6;
        if (_mountedRadio != "") then {
            if (getNumber(configFile >> "CfgWeapons" >> _mountedRadio >> "acre_hasUnique") == 1) then {
                //Init the radio
                ["acre_getRadioId", [_rack, _mountedRadio, QGVAR(returnRadioId)]] call CALLSTACK(CBA_fnc_globalEvent);
            };
        };

        _idx = _forEachIndex;
        _handled = true;
    };
} forEach _queue;

if (_idx != -1) then {
    _queue deleteAt _idx;
    _vehicle setVariable [QGVAR(queue), _queue];
};

if (!_handled) then {
    WARNING_2("Recieved new rack ID (%1) for vehicle (%2) but no entry in queue rack.",_rackId,typeOf _vehicle);
};
