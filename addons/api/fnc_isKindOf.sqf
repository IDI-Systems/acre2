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

private["_ret", "_parent", "_parentCheck", "_isAcre"];
params["_radioId", "_radioType"];

_ret = false;
_parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};

_isAcre = getNumber (configFile >> "CfgAcreComponents" >> _parent >> "isAcre");
// diag_log text format["_radioId: %1 isAcre: %2", _parent, _isAcre];
TRACE_2("", _parent, _isAcre);
if(_isAcre == 0) exitWith {
    false
};
TRACE_2("", _parent, _parentCheck);

if(_parent == _radioType) exitWith {
    true
};

if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};

if(_parent == _radioType) exitWith {
    true
};

while { _parent != "" } do {
    if(_parent == _radioType) exitWith {
        TRACE_2("", _parent, _radioType);
        true
    };
    _parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _parent));
};

_ret
