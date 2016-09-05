//fnc_sendDataEvent.sqf
#include "script_component.hpp"

if(isServer) then {
	_this call FUNC(serverPropDataEvent);
	_this call FUNC(onDataChangeEvent);
} else {
	ACREs = _this;
	publicVariableServer "ACREs";
};
