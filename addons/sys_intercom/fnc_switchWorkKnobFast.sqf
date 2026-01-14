#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the work knob switching keybind.
 *
 * Arguments:
 * 0: Work knob switch amount (expected -1 or 1) <NUMBER>
 * 1: Play sound <BOOL> (default: false)
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1, true] call acre_sys_intercom_fnc_switchWorkKnobFast
 *
 * Public: No
 */

params ["_dir", ["_playSound", false, [false]]];

private _vehicle = vehicle acre_player;
private _intercomNetwork = [_vehicle] call FUNC(getFirstConnectedIntercom);
if (_intercomNetwork < 0) exitWith {false};

private _workPos = [_vehicle, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);
private _success = [_intercomNetwork, _workPos + _dir] call FUNC(vic3ffcsSetWork);

if (!_success) exitWith {false};

if (_playSound) then {
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};

true
