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
#include "script_component.hpp"

#define DEBUG_MODE_REBUILD

params ["_eventKind","_radioId","_event",["_data",[]],["_remote",false]];

if (!HASH_HASKEY(GVAR(radioData), _radioId)) exitWith {
    WARNING_2("Non-existent radio '%1' called %2 radio event!",_radioId,_event);
    nil
};

private _radioData = HASH_GET(GVAR(radioData), _radioId);

//_return = nil;

private _radioBaseClass = getText(configFile >> "CfgWeapons" >> _radioId >> "acre_baseClass");

private _interfaceClass = getText(configFile >> "CfgAcreComponents" >> _radioBaseClass >> "InterfaceClasses" >> _eventKind);
if (_interfaceClass == "") then {
    _interfaceClass = "DefaultInterface";
};
private _handlerFunction = (getText (configFile >> "CfgAcreComponents" >> _radioBaseClass >> "Interfaces" >> _eventKind >> _event));

private _return = [_radioId, _event, _data, _radioData, _remote] call (missionNamespace getVariable[_handlerFunction, FUNC(noApiFunction)]);

if (isNil "_return") exitWith { nil };
_return;
