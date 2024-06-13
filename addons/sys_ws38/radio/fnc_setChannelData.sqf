#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the channel data. On a Wireless Set No. 38 this cannot be changed.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setChannelData" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_WS38_ID_1", "setChannelData", [], [], false] call acre_sys_ws38_fnc_setChannelData
 *
 * Public: No
 */

TRACE_1("", _this);
