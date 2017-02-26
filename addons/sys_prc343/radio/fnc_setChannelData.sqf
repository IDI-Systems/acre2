/*
 * Author: ACRE2Team
 * Sets the channel data. On a AN/PRC 343 this cannot be changed.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setChannelData" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_setChannelData
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("", _this);
