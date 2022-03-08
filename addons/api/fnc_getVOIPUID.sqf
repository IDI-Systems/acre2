#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Get the VOIP UID.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * VOIP UID <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getUID
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getVOIPUID)
