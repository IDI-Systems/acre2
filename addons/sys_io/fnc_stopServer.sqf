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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private _return = false;
if(!(scriptDone GVAR(processId))) then {
    GVAR(runServer) = false;
    waitUntil{(scriptDone GVAR(processId))}; // OK - TEMP
    waitUntil{(scriptDone GVAR(pingProcessId))}; // OK - TEMP
    _return = true;
};
[GVAR(serverHandle)] call CBA_fnc_removePerFrameHandler;
"ACRE2Arma" callExtension "1";

_return
