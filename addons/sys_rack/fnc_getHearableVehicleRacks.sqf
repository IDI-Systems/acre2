/*
 * Author: ACRE2Team
 * Returns the rack IDs for a specific vehicle that a player can hear.
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * Hearable racks <ARRAY>
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_rack_fnc_getHearableVehicleRacks
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _racks = [];
{
    private _rackId = typeOf _x;
    if (_rackId isKindOf "ACRE_BaseRack") then {
        if ([_rackId, _unit, _vehicle] call FUNC(isRackHearable)) then {
            _racks pushBack _rackId;
        };
    };
} forEach (attachedObjects _vehicle);

_racks
