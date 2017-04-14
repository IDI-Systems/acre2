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

private _wiredIntercoms = [_rackId] call FUNC(getWiredIntercoms);

("crew" in _wiredIntercoms && {_unit in ACRE_PLAYER_CREW_INTERCOM}) || ("passenger" in _wiredIntercoms && {_unit in ACRE_PLAYER_PASSENGER_INTERCOM})
