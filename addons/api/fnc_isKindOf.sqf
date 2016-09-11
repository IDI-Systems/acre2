/*
 * Author: ACRE2Team
 * Checks whether the provided weapon/item is the specified ACRE radio type.
 *
 * Arguments:
 * 0: Radio ID/Item classname <STRING>
 * 1: Radio base type <STRING>
 *
 * Return Value:
 * Whether the provided item is of the radio base type <BOOLEAN>
 *
 * Example:
 * _ret = ["ACRE_PRC117F_ID_123", "ACRE_PRC117F"] call acre_api_fnc_isKindOf;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioId", "_radioType"];

private _ret = false;
private _parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};

private _isAcre = getNumber (configFile >> "CfgAcreComponents" >> _parent >> "isAcre");
// diag_log text format["_radioId: %1 isAcre: %2", _parent, _isAcre];
TRACE_2("", _parent, _isAcre);
if(_isAcre == 0) exitWith {
    false
};
TRACE_2("", _parent, _radioType);

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
