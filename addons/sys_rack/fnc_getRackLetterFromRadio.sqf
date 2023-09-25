#include "script_component.hpp"
/*
 * Author: ACRE2Team, mrschick
 * Returns the rack letter if a radio is currently mounted.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Letter on Work knob corresponding to the rack, or "" if radio is not in a rack <STRING>
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_getRackLetterFromRadio
 *
 * Public: No
 */
 
params ["_radioId"];

private _return = "";

private _wiredRacks = [vehicle acre_player, acre_player, EGVAR(sys_intercom,activeIntercom), "wiredRacks"] call EFUNC(sys_intercom,getStationConfiguration);
{
    private _rackId = _x select 0;
    if (([_rackId] call FUNC(getMountedRadio)) == _radioId) exitWith {
        _return = [RACK_LETTERS] select _forEachIndex;
    };
} forEach _wiredRacks;

_return
