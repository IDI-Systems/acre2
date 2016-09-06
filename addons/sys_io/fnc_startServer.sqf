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
private ["_return", "_server", "_ping"];

#define __INTERVAL 0.001
GVAR(hasErrored) = false;
GVAR(connectCount) = 15;

// test dsound.dll
private["_testVal", "_fail", "_testFunc"];
GVAR(runserver) = true;
[] call FUNC(server);
LOG("server started");
GVAR(serverHandle) = ADDPFH(DFUNC(serverReadLoop), 0, []);
[] call FUNC(ping);


true
