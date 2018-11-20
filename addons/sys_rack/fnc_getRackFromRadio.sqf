#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the rack id if a radio is currently mounted.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * rack ID or "" if radio is not a rack <STRING>
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_getRackFromRadio
 *
 * Public: No
 */
 
params ["_radioId"];

private _return = "";

//TODO: Optimize
{
    private _rackId = typeOf _x;
    if (([_rackId] call FUNC(getMountedRadio)) == _radioId) exitWith {_return = _rackId;};
} forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

_return
