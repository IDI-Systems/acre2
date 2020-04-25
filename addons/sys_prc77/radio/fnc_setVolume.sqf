#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the volume of the current radio.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setVolume" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC77_ID_1", "volume", 0.8, _radioData, false] call acre_sys_prc77_fnc_setState] call acre_sys_prc77_fnc_setVolume
 *
 * Public: No
 */

TRACE_1("", _this);

params ["_radioId", "_event", "_eventData", "_radioData", ""];

TRACE_1("SETTING CURRENT VOLUME",_this);
HASH_SET(_radioData,"volume",_eventData);
