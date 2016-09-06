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

params ["_namespace", "_keyEvent", "_eventCode", ["_keyState","keydown"]];

private _configDataPrefix = "ACRE" + _namespace + _keyEvent;
private _keyCode = missionNamespace getVariable [_configDataPrefix + "keycode", -1];
private _shift = missionNamespace getVariable [_configDataPrefix + "shift", -1];
private _ctrl = missionNamespace getVariable [_configDataPrefix + "ctrl", -1];
private _alt = missionNamespace getVariable [_configDataPrefix + "alt", -1];
_params = [_keyEvent, _keyCode, _shift, _ctrl, _alt];
HASH_SET(GVAR(keyboardEvents), _keyEvent, _params);
if(_keyState == "keydown") then {
    HASH_SET(GVAR(keyboardEventsDown), _keyEvent, _eventCode);
} else {
    HASH_SET(GVAR(keyboardEventsUp), _keyEvent, _eventCode);
};
true
