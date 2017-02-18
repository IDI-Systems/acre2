/*
 * Author: ACRE2Team
 * Returns if an individual rack is accessible to a unit specific unit.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["acre_vrc110_id_1",acre_player] call acre_sys_rack_fnc_isRackAccessible;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "_unit", ["_vehicle", objNull]];

if (isNull _vehicle) then {
    _vehicle = [_rackId] call FUNC(getVehicleFromRack);
};
private _return = false;

private _allowed = [_rackId, "getState", "allowed"] call EFUNC(sys_data,dataEvent);
{
    if (_return) exitWith {};
    switch (_x) do{
        case "driver":{ if (driver _vehicle == _unit) then { _return = true; }; };
        case "gunner":{ if (gunner _vehicle == _unit) then { _return = true; }; };
        case "commander":{ if (commander _vehicle == _unit) then { _return = true; }; };
        case "inside":{ if (_vehicle == vehicle _unit) then { _return = true; }; };
        case "copilot":{
            private _crew = ((fullCrew _vehicle) select { getNumber ([_vehicle, _x select 3] call CBA_fnc_getTurret >> "isCopilot") == 1 }) apply {_x select 0};
            if (_unit in _crew) then { _return = true; };
        };
        case "external":{ if (_vehicle != vehicle _unit && {_vehicle distance _unit < 10}) then { _return = true; }; };
    };
} forEach _allowed;


_return;
