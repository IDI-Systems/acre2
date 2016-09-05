//fnc_getComponentTree.sqf
#include "script_component.hpp"

params["_componentId"];

private _searchedComponents = [];
private _searchFunction = {
	private ["_returnTree", "_componentData", "_connectorData", "_connector", "_x", "_connectorIndex", "_forEachIndex", "_connectedComponent", "_attributes", "_componentClass", "_componentSimple", "_ret"];
	_returnTree = [];
	params["_componentParentId"];
	PUSH(_searchedComponents, _componentParentId);
	_componentData = HASH_GET(acre_sys_data_radioData, _componentParentId);
	
	if(!isNil "_componentData") then {
		_connectorData = HASH_GET(_componentData, "acre_radioConnectionData");
		if(!isNil "_connectorData") then {
			{
				_connector = _x;
				_connectorIndex = _forEachIndex;
				if(!isNil "_connector") then {
					_connectedComponent = _connector select 0;
					_attributes = _connector select 2;
					_componentClass = configFile >> "CfgAcreComponents" >> _connectedComponent;
					_componentSimple = getNumber(_componentClass >> "simple");
					if(_componentSimple == 1) then {
						PUSH(_returnTree, ARR_3(_connectedComponent, _connectorIndex, []));
					} else {
						if(!(_connectedComponent in _searchedComponents)) then {
							_ret = [_connectedComponent] call _searchFunction;
							PUSH(_returnTree, ARR_3(_connectedComponent, _connectorIndex, _ret));
						};
					};
				};
			} forEach _connectorData;
		};
	};
	_returnTree;
};
[_componentId] call _searchFunction;