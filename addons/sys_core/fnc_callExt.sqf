#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function is used to make calls in acre.dll.
 *
 * Arguments:
 * 0: Command <STRING>
 * 1: Parameters <ANY>
 * 2: Threaded call if so uses the following arguments to handle the return (or value of 2 to do fast thread) <BOOL><NUMBER> (optional)
 * 3: Callback code <CODE> (optional)
 * 4: Return arguments <ANY> (optional)
 *
 * Return Value:
 * Return from call extension (nil when using fast thread) <ANY>
 *
 * Example:
 * ["init",[]] call acre_sys_core_fnc_callExt
 *
 * Public: No
 */

params ["_command", "_params", ["_threaded", false], ["_callBack",{}], ["_callBackArgs",[]]];

if (_threaded isEqualTo 2) exitWith {
    // callExtensionArgs has a max execution time of 1000ms, so cannot be used for some calls (like init)
    // need to be sure callExtension will parse arg array into an expected format
#ifdef USE_DEBUG_EXTENSIONS
    ("acre_dynload" callExtension ["calla", ["idi\acre\acre_x64.dll", _command] + _params]) params ["_msg", "_index"];
#else
    ("acre" callExtension [_command, _params]) params ["_msg", "_index"];
#endif
    TRACE_3("thread[new]",_command,_msg,_index);
    GVAR(threadedExtCalls) set [_index, [_callBackArgs, _callBack]];
};

private _paramsString = "";

if (IS_ARRAY(_params)) then {
    private _array = _params apply {
        private _element = _x;
        if (IS_ARRAY(_element)) then {
            (_element apply {
                if (IS_BOOL(_x)) then {
                    parseNumber _x
                } else {
                    _x
                };
            }) joinString ",";
        } else {
            if (IS_BOOL(_element)) then {
                parseNumber _element
            } else {
                _element
            };
        };
    };
    if !(_array isEqualTo []) then { _array pushBack ""; }; //Add empty element to add a trailing comma
    _paramsString = _array joinString ",";
};

_command = format["%1:%2", _command, _paramsString];
// diag_log text format["c: %1", _command];
#ifdef USE_DEBUG_EXTENSIONS
    private _res = "acre_dynload" callExtension format["call:%1,%2", "idi\acre\acre_x64.dll", _command];
#else
    private _res = "acre" callExtension _command;
#endif
_res = call compile _res;
if (_threaded) then {
    TRACE_1("thread[old]",_res);
    GVAR(threadedExtCalls) set [(_res select 1), [_callBackArgs, _callBack]];
};

_res;
