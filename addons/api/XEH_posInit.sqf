#include "script_component.hpp"

[QGVAR(initVehicleRacks), {
    params ["_vehicle"];

    [_vehicle] call EFUNC(sys_rack,initActionVehicle);
}] call CBA_fnc_addEventHandler;
