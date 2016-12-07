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

private _message = _this;
TRACE_1("RECEIEVED RPC DATA",_message);

private _procedureCall = (_message splitString ":") select 0;
if (isNil "_procedureCall") exitWith {};

TRACE_1("PROCEDURE CALL",_procedureCall);

private _restOfMessage = _message select [(count _procedureCall) +1];
private _paramArray = _restOfMessage splitString ",";

TRACE_1("PARAMS TO PROCEDURE",_paramArray);
if (HASH_HASKEY(GVAR(procedures), _procedureCall)) then {
    private _function = HASH_GET(GVAR(procedures), _procedureCall);
    TRACE_1("!!!!!!!!!!!!_---------------------------- CALLING FUNCTION -----------------!!!!!!",_procedureCall);
    // diag_log text format["CALL FUNC: %1", _function];
    _paramArray call CALLSTACK_NAMED(_function, _procedureCall);
};

true
