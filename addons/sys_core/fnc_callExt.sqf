/*
 * Author: ACRE2Team
 * This function is used to make calls in acre.dll
 *
 * Arguments:
 * 0: Command <STRING>
 * 1: Parameters <ANY>
 * 2: Threaded call if so uses the following arguments to handle the return <BOOLEAN> (optional)
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
#include "script_component.hpp"

params ["_command", "_params", ["_threaded", false], ["_callBack",{}], ["_callBackArgs",[]]];

private _paramsString = "";

if (IS_ARRAY(_params)) then {
    private _arrayParams = _params;
    {
        private _element = _x;
        if (IS_ARRAY(_element)) then {
            {
                if (!IS_STRING(_x)) then {
                    // Convert boolean to number.
                    if (IS_BOOL(_x)) then {
                        if (_x) then {
                            _x = 1;
                        } else {
                            _x = 0;
                        };
                    };
                    _paramsString = _paramsString + (str _x) + ","; // Convert number to string
                } else {
                    _paramsString = _paramsString + _x + ",";
                };
            } forEach _element;
        } else {
            if (!IS_STRING(_element)) then {
                // Convert boolean to number.
                if (IS_BOOL(_element)) then {
                    if (_element) then {
                        _element = 1;
                    } else {
                        _element = 0;
                    };
                };

                _paramsString = _paramsString + (str _element) + ","; // Convert number to string
            } else {
                _paramsString = _paramsString + _element + ",";
            };
        };

    } forEach _arrayParams;
};
_command = format["%1:%2", _command, _paramsString];
// diag_log text format["c: %1", _command];
#ifdef USE_DEBUG_EXTENSIONS
    private _res = "acre_dynload" callExtension format["call:%1,%2", "idi\build\win32\Debug\acre.dll", _command];
#else
    private _res = "acre" callExtension _command;
#endif
_res = call compile _res;
if (_threaded) then {
    GVAR(threadedExtCalls) set[(_res select 1), [_callBackArgs, _callBack]];
};

_res;
