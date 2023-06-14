#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Does nothing
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getStates" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getStates", [], [], false] call acre_sys_bf888s_fnc_getState] call acre_sys_bf888s_fnc_getStates
 *
 * Public: No
 */

TRACE_1("", _this);
