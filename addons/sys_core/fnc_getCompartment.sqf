#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Retrieves the compartment where the specified unit finds itself (driver, turret,...).
 * Relevant for signal attenuating purposes.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Compartment where the unit finds itself <STRING>. (default: "" if the unit is not inside a vehicle, "Compartment1" otherwise)
 *
 * Example:
 * [player] call acre_sys_core_fnc_getCompartment
 *
 * Public: No
 */

params ["_unit"];
private _vehicle = vehicle _unit;
private _compartment = "";
private _defaultCompartment = "";

if (_vehicle != _unit) then {
    private _defaultCompartment = "Compartment1";
    private _cfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
    private _assignedRole = assignedVehicleRole _unit;
    if ((_assignedRole select 0) == "Driver") then {
        _compartment = getText (_cfg >> "driverCompartments");
        if (_compartment == "") then {
            _compartment = _defaultCompartment;
        };
    } else {
        if ((_assignedRole select 0) == "Turret") then {
            private _turretPath = _assignedRole select 1;
            private _turret = [_vehicle, _turretPath] call CBA_fnc_getTurret;
            _compartment = getText (_turret >> "gunnerCompartments");
            if (_compartment == "") then {
                _compartment = getText (_cfg >> "driverCompartments");
                if (_compartment == "") then {
                    _compartment = _defaultCompartment;
                };
            };
        } else {
            if ((_assignedRole select 0) == "Cargo") then {
                private _cargoCompartments = getArray (_cfg >> "cargoCompartments");
                if !(_cargoCompartments isEqualTo []) then {
                    private _index = -1;
                    // if ((productVersion select 3) < 126064) then {
                        // _index = (count _attenuateCargo)-1; // wait for command to get cargo index
                    // } else {
                        _index = _vehicle getCargoIndex _unit;
                    // };
                    if (_index > -1) then {
                        if (_index > (count _cargoCompartments) - 1) then {
                            _index = (count _cargoCompartments) - 1;
                        };

                        _compartment = _cargoCompartments select _index;
                    } else {
                        _compartment = _defaultCompartment;
                    };
                } else {
                    _compartment = _defaultCompartment;
                };
            };
        };
    };
};
if !(_compartment isEqualType "") then {
    _compartment = _defaultCompartment;
};
_compartment;
