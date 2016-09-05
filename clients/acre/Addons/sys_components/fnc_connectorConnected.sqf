//fnc_connectorConnected.sqf
#include "script_component.hpp"

params["_componentId","_connector"];

private _componentData = HASH_GET(acre_sys_data_radioData, _componentId);

private _return = false;
if(!isNil "_componentData") then {
	if(_connector < (count _componentData)) then {
		private _test = _componentData select _connector;
		if(!isNil "_test") then {
			_return = true;
		};
	};
};
_return;
