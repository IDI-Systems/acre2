#include "script_component.hpp"

/*
 * Author: Killerswin2
 * Get the VOIP UID name
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: VOIP UID name <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getUID
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getUID)
