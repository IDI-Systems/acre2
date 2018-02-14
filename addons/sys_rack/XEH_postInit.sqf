#include "script_component.hpp"

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

["vehicle", {
    params ["_player", "_newVehicle"];
    [_newVehicle, _player] call FUNC(enterVehicle);
}] call CBA_fnc_addPlayerEventHandler;

// Handle the case of starting inside a vehicle
if (vehicle acre_player != acre_player) then {
    [{
        params ["_vehicle", "_player"];
        [_vehicle, _player] call FUNC(enterVehicle)
    }, [vehicle acre_player, acre_player]] call CBA_fnc_execNextFrame;
};

["LandVehicle", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Air", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Ship_F", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;

// EH for vehicle racks
[QGVAR(returnRackId), { _this call FUNC(onReturnRackId) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);
