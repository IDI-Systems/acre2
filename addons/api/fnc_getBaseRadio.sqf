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
private["_parent", "_hasUnique"];
params["_radioId"];

TRACE_1("", _radioId);
if( ([_radioId] call FUNC(isBaseRadio)) ) exitWith {
    _radioId
};

_parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};
_hasUnique = 0;
while { _hasUnique != 1 && _parent != ""} do {
    _hasUnique = getNumber(configFile >> "CfgWeapons" >> _parent >> "acre_hasUnique");
    if(_hasUnique != 1) then {
        _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _parent));
    };
};

_parent
