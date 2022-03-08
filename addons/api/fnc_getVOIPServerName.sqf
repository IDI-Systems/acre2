#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Get the VOIP server name.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * VOIP Server Name <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getVOIPServerName
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getVOIPServerName)
