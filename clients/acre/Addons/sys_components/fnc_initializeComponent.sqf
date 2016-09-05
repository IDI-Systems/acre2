//fnc_initializeComponent.sqf
#include "script_component.hpp"

private ["_return"];

params["_radioId","_event","_data", "_radioData", "_eventKind", "_remote"];

private _parentComponentClass = configFile >> "CfgAcreComponents" >> (getText(configFile >> "CfgWeapons" >> _radioId >> "acre_baseClass"));

private _connectorData = HASH_GET(_radioData, "acre_radioConnectionData");
if(isNil "_connectorData") then {
	_connectorData = [];
	HASH_SET(_radioData, "acre_radioConnectionData", _connectorData);
};
{
	// diag_log text format["x: %1", _x];
	_x params["_connector", "_component"];

	private _attributes = HASH_CREATE;
	private _componentClass = configFile >> "CfgAcreComponents" >> _component;
	if(!isClass(_componentClass)) exitWith { diag_log text format["%1 ACRE ERROR: %2 is not a class type of CfgAcreComponents", diag_tickTime, _component]; };
	
	private _componentSimple = getNumber(_componentClass >> "simple");
	if(_componentSimple == 1) then {
		private _parentConnectorType = ((getArray(_parentComponentClass >> "connectors")) select _connector) select 1;
		private _childConnectorType = getNumber(_componentClass >> "connector");
		// diag_log text format["%3 _parentConnectorType: %1 _childConnectorType: %2", _parentConnectorType, _childConnectorType, _componentClass];
		if(_parentConnectorType == _childConnectorType) then {
			_connectorData set[_connector, [_component, 0, _attributes]];
			// diag_log text format["init _connectorData: %1", _connectorData];
			_return = true;
		};
	} else {
		diag_log text format["%1 ACRE WARNING: Tried to initialize non-simple component attachment %2 on %3", diag_tickTime, _component, _radioId];
	};
} forEach (getArray(_parentComponentClass >> "defaultComponents"));

_this call EFUNC(sys_data,handleSetData);
