#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles a unit pressing the PTT key when having the intercom in PTT configuration.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Voice activation active <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player, true] call acre_sys_intercom_fnc_handleIntercomActivation
 *
 * Public: No
 */

params ["_unit", "_voiceActivation"];

// TODO: Remove synchronisation once intercom system has been converted to components and unique IDs.
//       It will help in reduce the bandwith, since information will be exchanged through the TS plugin.
_unit setVariable [QGVAR(intercomPTT), _voiceActivation, true];
GVAR(intercomPttKey) = _voiceActivation;

if (_voiceActivation) then {
    ["startIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
} else {
    ["stopIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
};
