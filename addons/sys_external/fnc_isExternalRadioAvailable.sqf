/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_radio_allowExternalUse
 *
 * Public: No
 */
#include "script_component.hpp"

/* TODO:
 * - Consider further corner cases.
 */

params ["_radioId"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);

// Check if actual owner of the radio is less than 2.0m away.
if ((_owner distance acre_player) > 2.0) exitWith {false};

// Check if actual owner of the radio and the player are on the same vehicle.
if ((vehicle _owner != _owner) && (vehicle acre_player != acre_player) && (vehicle _owner != vehicle acre_player)) exitWith {false};

true
