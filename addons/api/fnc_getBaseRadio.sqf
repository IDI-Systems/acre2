/*
 * Author: ACRE2Team
 * Takes an actual unique radio ID, and returns its actual base radio type
 *
 * Arguments:
 * 0: Radio item name with ID <STRING>
 *
 * Return Value:
 * The base radio class <STRING>
 *
 * Example:
 * ["ACRE_PRC148_ID_15"] call acre_api_fnc_getBaseRadio;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioId"];

TRACE_1("", _radioId);
if( ([_radioId] call FUNC(isBaseRadio)) ) exitWith {
    _radioId
};

private _parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};
private _hasUnique = 0;
while { _hasUnique != 1 && _parent != ""} do {
    _hasUnique = getNumber(configFile >> "CfgWeapons" >> _parent >> "acre_hasUnique");
    if(_hasUnique != 1) then {
        _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _parent));
    };
};

_parent
