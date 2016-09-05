//#define DEBUG_MODE_FULL
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