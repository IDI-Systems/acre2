#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Calls the RPC associated to the VOIP server info.
 *
 * Arguments:
 * None
 *
 * Return:
 *  <none>
 *
 * Example:
 * [] call acre_sys_core_fnc_updateServerInfo
 *
 * Public: No
 */

CALL_RPC("getVOIPServerName","");
CALL_RPC("getVOIPChannelName","");
CALL_RPC("getVOIPUID","");
