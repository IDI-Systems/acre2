#include "script_component.hpp"

/*
 * Author: Killerswin2
 * Get the VOIP server name
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0. VOIP server name <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getServerName
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getServerName)
