#include "script_component.hpp"
/*
 * Author: mrschick
 * Replaces all config-defined Racks on a vehicle with a different class of Rack, while keeping the same name, allowedPositions, etc.
 * Must be executed on the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 * 1: Rack classname to remove <STRING> (default: "")
 * 2: Rack classname to add <STRING> (default: "")
 * 3: Condition called with argument "_unit" for rack init. If a longer function is given, it should be precompiled. <CODE> (default: {})
 *
 * Return Value:
 * Racks replaced successfully <BOOL>
 *
 * Example:
 * [cursorTarget, "ACRE_VRC103", "ACRE_VRC64", {}] call acre_api_fnc_replaceRacksOnVehicle
 *
 * Public: Yes
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_fromRack", "", [""]],
    ["_toRack", "", [""]],
    ["_condition", {}, [{}]]
];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to remove a rack from an undefined vehicle %1",_vehicle);
    false
};

if (_fromRack == "" || {_toRack == ""}) exitWith {
    WARNING_1("Racks to replace on vehicle %1 were not defined",_vehicle);
    false
};

if (_fromRack == _toRack) exitWith {
    WARNING_1("Racks on vehicle %1 and intended replacements are the same",_vehicle);
    false
};

// Store the desired Rack replacement as an object var which will be handled by sys_rack/fnc_initVehicle on the next initialization
_vehicle setVariable [QEGVAR(sys_rack,replaceRacks), [_fromRack, _toRack], true];

if ([_vehicle] call FUNC(areVehicleRacksInitialized)) then {
    // If Racks have already been initialized, revert the initialization to run this function again
    [_vehicle, _condition] call FUNC(removeAllRacksFromVehicle);

    [{
        params ["_vehicle"];
        (_vehicle getVariable [QEGVAR(sys_rack,vehicleRacks), []]) isEqualTo []
    }, {
        params ["_vehicle"];

        _vehicle setVariable [QEGVAR(sys_rack,initialized), false, true];

        private _success = true;
        WARNING_1("Forcing initialisation of vehicle %1 in order to alter all racks",_vehicle);
        _success = [_vehicle, _condition] call EFUNC(api,initVehicleRacks);

        if (!_success) exitWith {
            WARNING_1("Vehicle %1 failed to initialise",_vehicle);
        };
    }, [_vehicle]] call CBA_fnc_waitUntilAndExecute;
};

true
