/*
 * Author: ACRE2Team
 * Used to handle a keypress for intercom PTT transmission.
 *
 * Arguments:
 * 0: Action <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_intercom_fnc_handlePttKeyPress
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_action"];

if (ACRE_IS_SPECTATOR) exitWith { true };

private _vehicle = vehicle acre_player;

if (_vehicle ==  acre_player) exitWith { true };

switch (_action) do {
    case 0 : { GVAR(intercomPttKey) = true; [acre_player, true] call FUNC(handleIntercomActivation); };
    case 1 : { GVAR(broadcastKey) = true; [_vehicle, acre_player, ALL_INTERCOMS, true] call FUNC(handleBroadcasting); };
};

[_vehicle, acre_player] call FUNC(vehicleInfoLine);

true
