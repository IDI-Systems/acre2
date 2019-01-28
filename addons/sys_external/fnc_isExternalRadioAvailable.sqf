#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a radio is externally available to the player.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: Radio owner <OBJECT>
 *
 * Return Value:
 * Radio is available for external use <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_isExternalRadioAvailable
 *
 * Public: No
 */

/* TODO:
 * - Consider further corner cases.
 */

params ["_radioId", "_owner"];

// Check if actual owner of the radio is less than 2.0m away.
if (((_owner distance acre_player) > EXTERNAL_RADIO_MAXDISTANCE) && {vehicle _owner != vehicle acre_player}) exitWith {false};

// Captive players are not allowed to use external radios
if (captive acre_player) exitWith {false};

// Check if actual owner of the radio and the player are on the same vehicle.
!((vehicle _owner != _owner) && {vehicle acre_player != acre_player} && {vehicle _owner != vehicle acre_player})
