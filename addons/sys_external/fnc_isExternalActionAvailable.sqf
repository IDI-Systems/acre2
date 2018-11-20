#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the player can perform external actions on shared radios.
 *
 * Arguments:
 * 0: Infantry unit <OBJECT>
 *
 * Return Value:
 * Can interact with external radios <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_external_isExternalRadioAvailable
 *
 * Public: No
 */

params ["_target"];

// Check first distance to the unit
if ((_target distance acre_player) > EXTERNAL_RADIO_MAXDISTANCE) exitWith {false};

// Action is available if the unit has shared radios.
private _sharedRadios = [_target] call FUNC(getSharedExternalRadios);
private _radiosInUse = _sharedRadios select {[_x] call FUNC(isExternalRadioUsed)};

// Of those radios that are in use, only the ones used by the player count
{
    if (acre_player != [_x] call FUNC(getExternalRadioUser))  then {
        _sharedRadios deleteAt (_sharedRadios find _x);
    };
} forEach _radiosInUse;

// If the player has external radios in use, the action to give or return radios should be also available
!(_sharedRadios isEqualTo []) || {!(ACRE_ACTIVE_EXTERNAL_RADIOS isEqualTo [])}
