#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the receipt of messages from the teamspeak plugin. Firstly by de-serializing the recieved message. It will then call any procedure handlers.
 *
 * Arguments:
 * 0: Message <STRING>
 *
 * Return Value:
 * Handled (returns true if a handler was called) <BOOL>
 *
 * Example:
 * ["localStopSpeaking:1,0,'',"] call acre_sys_rpc_fnc_handleData
 *
 * Public: No
 */

private _message = _this;
TRACE_1("RECEIEVED RPC DATA",_message);

private _procedureCall = (_message splitString ":") select 0;
if (isNil "_procedureCall") exitWith {false};

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
