/*
 * Author: ACRE2Team
 * Returns if an individual rack is hearable (in intercom) to a specific unit.
 *
 * Arguments:
 * 0: Unque rack ID <STRING>
 * 1: Unit <OBJECT>
 * 2: Vehicle <OBJECT><OPTIONAL>
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["acre_vrc110_id_1",acre_player] call acre_sys_rack_fnc_isRackHearable;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "_unit", ["_vehicle", objNull]];

if (isNull _vehicle) then {
    _vehicle = [_rackId] call FUNC(getVehicleFromRack);
};

if (!alive _vehicle) exitWith {false};

// Infantry phone units are not allowed
if (_unit == vehicle _unit) exitWith {false};

private _wiredIntercoms = [_rackId] call FUNC(getWiredIntercoms);

private _isHearable = false;
{
    _isHearable = [_vehicle, _unit, _forEachIndex] call EFUNC(sys_intercom,isInIntercom);
    if (_isHearable) exitWith{};
} forEach (_vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []]);

_isHearable
