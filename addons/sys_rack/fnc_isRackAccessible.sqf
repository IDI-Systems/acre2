#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns if an individual rack is accessible to a specific unit.
 *
 * Arguments:
 * 0: Unque rack ID <STRING>
 * 1: Unit <OBJECT>
 * 2: Vehicle <OBJECT><OPTIONAL> (default: objNull)
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["acre_vrc110_id_1",acre_player] call acre_sys_rack_fnc_isRackAccessible;
 *
 * Public: No
 */

params ["_rackId", "_unit", ["_vehicle", objNull]];

if (isNull _vehicle || {vehicle _unit == _unit}) then {
    _vehicle = [_rackId] call FUNC(getVehicleFromRack);
};

private _allowedPositions = [_rackId, "getState", "allowed"] call EFUNC(sys_data,dataEvent);
private _disabledPositions = [_rackId, "getState", "disabled"] call EFUNC(sys_data,dataEvent);

[_vehicle, _unit, _allowedPositions, _disabledPositions, MAX_EXTERNAL_RACK_DISTANCE] call EFUNC(sys_core,hasAccessToVehicleSystem)
