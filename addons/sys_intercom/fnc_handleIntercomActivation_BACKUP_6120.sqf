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

_unit setVariable [QGVAR(intercomPTT), _voiceActivation, true];

if (_voiceActivation) then {
<<<<<<< Updated upstream
    ["startIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
} else {
    ["stopIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
=======
    ["startIntercomSpeaking"] call EFUNC(sys_rpc,callRemoteProcedure);
} else {
    ["stopIntercomSpeaking"] call EFUNC(sys_rpc,callRemoteProcedure);
>>>>>>> Stashed changes
}
