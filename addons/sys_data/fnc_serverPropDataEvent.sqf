//fnc_serverPropDataEvent.sqf
#include "script_component.hpp"

GVAR(serverNetworkIdCounter) = GVAR(serverNetworkIdCounter) + 1;
ACREc = [GVAR(serverNetworkIdCounter), _this select 0, _this select 1];
publicVariable "ACREc";
if(isServer) then {
    [GVAR(serverNetworkIdCounter), _this select 0, _this select 1] call FUNC(onDataChangeEvent);
};
