#include "script_component.hpp"

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};

["vehicle", {
    params ["_player", "_newVehicle"];
    [_newVehicle, _player] call FUNC(enterVehicle);
}] call CBA_fnc_addPlayerEventHandler;

["LandVehicle", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Air", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Ship_F", "init", FUNC(initActionVehicle), nil, nil, true] call CBA_fnc_addClassEventHandler;

// EH for vehicle racks
[QGVAR(returnRackId), { _this call FUNC(onReturnRackId) }] call CALLSTACK(CBA_fnc_addEventHandler);

/*
[{
    ["vehicle", {[] call FUNC(monitorVehicle);}] call CBA_fnc_addPlayerEventHandler;
}, {ACRE_DATA_SYNCED}, []] call CBA_fnc_waitUntilAndExecute;
*/

/*

// radio claiming handler

["acre_handleDesyncCheck", { _this call FUNC(handleDesyncCheck) }] call CALLSTACK(CBA_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK
*/
[QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);

ADDPFH(DFUNC(vehicleCrewPFH), 0.91, []);
