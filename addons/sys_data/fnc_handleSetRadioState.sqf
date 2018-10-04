#include "script_component.hpp"
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

params ["_radioId", "_event", "_eventData", "_radioData"];
// diag_log text format["!!!!!!!!SET RADIO STATE EVENT: %1", _this];

private _radioState = HASH_GET(_radioData,"acre_radioState");
if (isNil "_radioState") then {
    _radioState = HASH_CREATE;
    HASH_SET(_radioData,"acre_radioState",_radioState);
};
{
    if (IS_ARRAY(_x)) then {
        if ((count _x) == 2) then {
            _x params ["_key","_val"];
            if (IS_STRING(_key)) then {
                TRACE_2("SETTING RADIO STATE",_key,_val);
                HASH_SET(_radioState,_key,_val);
            };
        };
    };
} forEach _eventData;
