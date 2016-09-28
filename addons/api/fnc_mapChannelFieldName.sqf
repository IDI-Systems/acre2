/*
 * Author: ACRE2Team
 * Used to get the correct channel field name for a particular radio type. As the field names can differ between radio IDs.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Field Name <STRING>
 *
 * Return Value:
 * Field name <STRING>
 *
 * Example:
 * ["ACRE_PRC148_ID_1","description"] call acre_api_fnc_mapChannelFieldName;
 *
 * Deprecated
 */
#include "script_component.hpp"

params["_radioId", "_fieldName"];

TRACE_1("CALLING", "");
private _baseRadio = [_radioId] call FUNC(getBaseRadio);
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
