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

params["_radio"];

private _side = "CENTER";

if(!(isNil "_radio")) then {
    private _isInitialized = [_radio] call EFUNC(sys_data,isRadioInitialized);
//    diag_log format["STATE WTF: %1=%2", _radio, _state];
    if(_isInitialized) then {
        private _spatial = [_radio, "getSpatial"] call EFUNC(sys_data,dataEvent);

        switch(_spatial) do {
            case -1: {
                _side = "LEFT";
            };
            case 1: {
                _side = "RIGHT";
            };
            case 0: {
                _side = "CENTER";
            };
            default {
                _side = "CENTER";
            };
        };
    };
};

_side
