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
 * Public: Yes
 */
#include "script_component.hpp"

private["_baseRadio"];
params["_radioId", "_fieldName"];


TRACE_1("CALLING", "");
_baseRadio = [_radioId] call FUNC(getBaseRadio);
TRACE_1("", _baseRadio);
switch _baseRadio do {
    case "ACRE_PRC148": {
        if(_fieldName == "description" || _fieldName == "name") then {
            _fieldName = "label";
        };
    };
    case "ACRE_PRC152": {
        if(_fieldName == "name" || _fieldName == "label") then {
            _fieldName = "description";
        };
    };
    case "ACRE_PRC117F": {
        if(_fieldName == "description" || _fieldName == "label") then {
            _fieldName = "name";
        };
    };
};

_fieldName
