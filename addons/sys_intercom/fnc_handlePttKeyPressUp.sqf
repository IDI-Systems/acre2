#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a key up for intercom PTT transmission.
 *
 * Arguments:
 * 0: Action <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_intercom_fnc_handlePttKeyPressUp
 *
 * Public: No
 */

params ["_action"];

if (ACRE_IS_SPECTATOR) exitWith { true };

private _vehicle = vehicle acre_player;

if (_vehicle == acre_player) exitWith { true };

// After the PTT release delay, unless pressed again meanwhile.
[QGVAR(ptt), {
    params ["_action", "_vehicle"];
    switch (_action) do {
        case ACTION_INTERCOM_PTT: {[acre_player, false] call FUNC(handleIntercomActivation);};
        case ACTION_BROADCAST: {[_vehicle, acre_player, ALL_INTERCOMS, false] call FUNC(handleBroadcasting);};
    };

    [_vehicle, acre_player] call FUNC(updateVehicleInfoText);
}, [_action, _vehicle]] call EFUNC(sys_core,pttReleased);

true
