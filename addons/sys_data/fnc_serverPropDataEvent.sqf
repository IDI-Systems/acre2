#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_serverPropDataEvent
 *
 * Public: No
 */

GVAR(serverNetworkIdCounter) = GVAR(serverNetworkIdCounter) + 1;
ACREc = [GVAR(serverNetworkIdCounter), _this select 0, _this select 1];
publicVariable "ACREc";
if (isServer) then {
    [GVAR(serverNetworkIdCounter), _this select 0, _this select 1] call FUNC(onDataChangeEvent);
};
