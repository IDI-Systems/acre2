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

params ["_object", "_variable", "_value", ["_checkTimeFrame", 5]];

// does setVariable public also work for other types ??
if (typeName _object != typeName "OBJECT" && typeName _object == "GROUP") exitWith {
    WARNING("The first parameter is not of type object or group!");
    false
};

private _var = _object getVariable _variable;

if (isNil "_var") exitWith {
    TRACE_3("Broadcasting",_object,_variable,_value);
    _object setVariable [_variable, _value, true];
    true
};

private _s = if (typeName _value != typeName _var) then {
    TRACE_2("Different typenames",_var,_value);
    false
} else {
    switch (typename _value) do {
        case "BOOL": {
            ((_var && _value) || (!_var && !_value))
        };
        case "ARRAY": {
            ([_var, _value] call CALLSTACK(BIS_fnc_areEqual))
        };
        case "CODE": {
            false
        };
        case "SCRIPT": {
            false
        };
        default {
            (_var == _value)
        };
    }
};

// now check the timer to broadcast, broadcast if > 5 seconds since last set
private _lastTestTime = _object getVariable [_variable + "_t", 0];
if ((COMPAT_diag_tickTime - _lastTestTime) > _checkTimeFrame) exitWith {
    TRACE_3("Broadcasting",_object,_variable,_value);
    _object setVariable [_variable, _value, true];
    _lastTestTime = _object setVariable [_variable + "_t", COMPAT_diag_tickTime, false];
};

if (_s) exitwith {
    TRACE_2("Not broadcasting, _var and _value are equal",_var,_value);
    false
};

TRACE_3("Broadcasting",_object,_variable,_value);
_object setVariable [_variable, _value, true];

true
