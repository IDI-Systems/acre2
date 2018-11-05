#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the local player stop speaking event.
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_localStopSpeaking
 *
 * Public: No
 */

TRACE_1("LOCAL STOP SPEAKING ENTER", _this);

["acre_stoppedSpeaking", [acre_player, ACRE_LOCAL_BROADCASTING]] call CBA_fnc_localEvent; // [unit, on radio]
ACRE_LOCAL_SPEAKING = false;
ACRE_LOCAL_BROADCASTING = false;

//ACRE_BROADCASTING_RADIOID = "";
if (isNil "ACRE_CustomVolumeControl") then {
    [] call EFUNC(sys_gui,closeVolumeControl); // reset voice curve.
};

//[str GVAR(ts3id), netId acre_player] call FUNC(remoteStopSpeaking);

true
