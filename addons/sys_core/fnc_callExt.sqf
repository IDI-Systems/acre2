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

#define FORMAT_NUMBER(num) (num call FUNC(formatNumber))

params ["_command", "_params", ["_threaded", false], ["_callBack",{}], ["_callBackArgs",[]]];

private _paramsString = "";
_res = nil;
if(IS_ARRAY(_params)) then {
    private _arrayParams = _params;
    {
        private _element = _x;
        if(IS_ARRAY(_element)) then {
            {
                if(!IS_STRING(_x)) then {
                    if(IS_BOOL(_x)) then {
                        if(_x) then {
                            _x = 1;
                        } else {
                            _x = 0;
                        };
                    };
                    // if(IS_NUMBER(_x)) then {
                        // _x = FORMAT_NUMBER(_x);
                        // _paramsString = _paramsString + _x + ",";
                    // } else {
                        _paramsString = _paramsString + (str _x) + ",";
                    // };
                } else {
                    _paramsString = _paramsString + _x + ",";
                };
            } forEach _element;
        } else {
            if(!IS_STRING(_element)) then {
                if(IS_BOOL(_element)) then {
                    if(_element) then {
                        _element = 1;
                    } else {
                        _element = 0;
                    };
                };

                // if(IS_NUMBER(_element)) then {
                    // _element = FORMAT_NUMBER(_element);
                    // _paramsString = _paramsString + _element + ",";
                // } else {
                    _paramsString = _paramsString + (str _element) + ",";
                // };
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
if(_threaded) then {
    GVAR(threadedExtCalls) set[(_res select 1), [_callBackArgs, _callBack]];
};

_res;
