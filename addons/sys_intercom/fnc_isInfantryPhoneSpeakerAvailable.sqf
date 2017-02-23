/*
 * Author: ACRE2Team
 * Checks the availability of the infantry phone speaker action.
 *
 * Arguments:
 * 0: Vehicle with an intercom action <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Speaker action is available <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_isInfantryPhoneSpeakerAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

// Only show for actual crew members. Not someone in cargo...
params ["_vehicle", "_unit"];

private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
{
    _crew pushBackUnique (_vehicle turretUnit _x);
} forEach (allTurrets [_vehicle, false]);
_crew = _crew - [objNull];

if (_unit in _crew) exitWith {true};

false
