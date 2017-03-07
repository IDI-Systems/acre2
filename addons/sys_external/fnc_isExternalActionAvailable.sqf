/*
 * Author: ACRE2Team
 * Checks if the player can perform external actions on shared radios
 *
 * Arguments:
 * 0: Infantry unit <OBJECT>
 *
 * Return Value:
 * False
 *
 * Example:
 * [cursorTarget] call acre_sys_external_isExternalRadioAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

// Action is available if the unit has shared radios.
private _sharedRadios = [_target] call FUNC(getSharedExternalRadios);
private _radiosInUse = _sharedRadios select {[_x] call FUNC(isExternalRadioUsed)};

// Of those radios that are in use, only the ones used by the player count
{
    if (acre_player != [_x] call FUNC(getExternalRadioUser))  then {
        _sharedRadios = _sharedRadios - [_x];
    };
} forEach _radiosInUse;

if (count _sharedRadios > 0) exitWith { true };

// If the player has external radios in use, the action to give or return radios should be also available
if (count ACRE_ACTIVE_EXTERNAL_RADIOS > 0) exitWith {true};

// Action is available if the player has shared radios.
private _sharedRadios = [acre_player] call FUNC(getSharedExternalRadios);
private _radiosInUse = _sharedRadios select {[_x] call FUNC(isExternalRadioUsed)};

// Of those radios that are in use, only the ones used by the player count
{
    if (acre_player != [_x] call FUNC(getExternalRadioUser))  then {
        _sharedRadios = _sharedRadios - [_x];
    };
} forEach _radiosInUse;

if (count _sharedRadios > 0) exitWith { true };

false
