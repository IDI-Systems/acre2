/*
 * Author: AUTHOR
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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

#include "script_component.hpp"
TRACE_1("LOCAL STOP SPEAKING ENTER", _this);
ACRE_LOCAL_SPEAKING = false;
ACRE_LOCAL_BROADCASTING = false;
//ACRE_BROADCASTING_RADIOID = "";
if(isNil "ACRE_CustomVolumeControl") then {
    [] call EFUNC(sys_gui,closeVolumeControl); // reset voice curve.
};

//[str GVAR(ts3id), netId acre_player] call FUNC(remoteStopSpeaking);

true
