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

params["_name","_params"];

if(IS_ARRAY(_params)) then {
    private _arrayParams = _params;
    _params = "";
    {
        _element = _x;
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
                    _params = _params + (str _x) + ",";
                } else {
                    _params = _params + _x + ",";
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
                _params = _params + (str _element) + ",";
            } else {
                _params = _params + _element + ",";
            };
        };

    } forEach _arrayParams;
};
private _data = _name + ":" + _params;
TRACE_1("sendMessage ", _data);
_data call EFUNC(sys_io,sendMessage);
