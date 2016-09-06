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

TRACE_1("", _this);

params["_configPath"];

private _run = format["if(isClass(missionConfigFile >> %1 )) then { (missionConfigFile >> %1 ) } else { nil }", _configPath];
private _go = compile _run;
private _ret = call CALLSTACK(_go);

TRACE_1("", _ret);

if(isNil "_ret") then {
    _run = format["if(isClass(configFile >> %1 )) then { (configFile >> %1 ) } else { nil }", _configPath];
    _go = compile _run;
    _ret = call CALLSTACK(_go);
};

TRACE_1("", _ret);

_ret
