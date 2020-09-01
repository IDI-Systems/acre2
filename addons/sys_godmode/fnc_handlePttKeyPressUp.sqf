#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * 0: Group index (0-based index) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_godmode_fnc_handlePttKeyPressUp
 *
 * Public: No
 */

params ["_group"];

if !([_group] call FUNC(accessAllowed)) exitWith { false };

[QGVAR(stopSpeaking), [EGVAR(sys_core,ts3id)], GVAR(targetUnits)] call CBA_fnc_targetEvent;
GVAR(targetUnits) = [];

["stopGodModeSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

#ifndef ALLOW_SELF_RX
["Acre_GodPingOff", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false] call EFUNC(sys_sounds,playSound);
#endif

if (GVAR(txNotificationLayer) != "") then {
    [GVAR(txNotificationLayer)] call EFUNC(sys_list,hideHint);
    GVAR(txNotificationLayer) = "";
};

true
