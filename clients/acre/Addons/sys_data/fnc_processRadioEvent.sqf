//fnc_processRadioEvent.sqf
#include "script_component.hpp"
 
#define DEBUG_MODE_REBUILD

params["_eventKind","_radioId","_event",["_data",[]],["_remote",false]];

if(!HASH_HASKEY(GVAR(radioData), _radioId)) exitWith {
    diag_log text format["%1 ACRE WARNING: Non-existent radio '%2' called %3 radio event!", diag_tickTime, _radioId, _event];
    nil;
};

private _radioData = HASH_GET(GVAR(radioData), _radioId);

//_return = nil;

private _radioBaseClass = getText(configFile >> "CfgWeapons" >> _radioId >> "acre_baseClass");

private _interfaceClass = getText(configFile >> "CfgAcreComponents" >> _radioBaseClass >> "InterfaceClasses" >> _eventKind);
if(_interfaceClass == "") then {
	_interfaceClass = "DefaultInterface";
};
private _handlerFunction = (getText (configFile >> "CfgAcreComponents" >> _radioBaseClass >> "Interfaces" >> _eventKind >> _event));

private _return = [_radioId, _event, _data, _radioData, _remote] call (missionNamespace getVariable[_handlerFunction, FUNC(noApiFunction)]);

if(isNil "_return") exitWith { nil };
_return;
