#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Ask server to pause ACRE globally
 *
 * Arguments:
 * 0: Enable/Disable <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_setPaused
 *
 * Public: Yes
 */

params["_pause"];

[_pause] call EFUNC(sys_core,setPaused);
