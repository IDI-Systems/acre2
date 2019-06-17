#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles closing the intercom GUI.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * GUI successfully closed <BOOL>
 *
 * Example:
 * [1, true] call acre_sys_intercom_fnc_closeGui
 *
 * Public: No
 */

// The case of a player exiting a vehicle with UI opened is handled in the vehicle CBA EH
if (vehicle acre_player isEqualTo acre_player) exitWith {false};

GVAR(guiOpened) = false;
GVAR(activeIntercom) = -1;

[vehicle acre_player, acre_player] call FUNC(updateVehicleInfoText);

if (GVAR(configChanged)) then {
    [vehicle acre_player, acre_player] call FUNC(saveStationConfiguration);
};

true
