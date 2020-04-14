#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function is used to make calls in acre.dll.
 *
 * Arguments:
 * 0: Command <STRING>
 * 1: Parameters <ANY>
 * 2: Threaded call if so uses the following arguments to handle the return <BOOL> (optional)
 * 3: Callback code <CODE> (optional)
 * 4: Return arguments <ANY> (optional)
 *
 * Return Value:
 * Return from call extension <ANY>
 *
 * Example:
 * ["init",[]] call acre_sys_core_fnc_callExt
 *
 * Public: No
 */

params ["_command", "_params", ["_threaded", false], ["_callBack",{}], ["_callBackArgs",[]]];

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
    private _res = "acre_dynload" callExtension format["call:%1,%2", "idi\build\win32\Debug\acre.dll", _command];
#else
    private _res = "acre" callExtension _command;
#endif

if (_threaded) then {
    (parseSimpleArray _res) params ["", "_index"];
    GVAR(threadedExtCalls) set [_index, [_callBackArgs, _callBack]];
    // TRACE_2("new thread",_res,_index);
} else {
    _res = call compile _res;
};

_res;
