#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the channel data. It consists of mode, transmitting and receiving frequencies and power
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannelData" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Hash with mode, transmitting and receiving frequencies and power <HASH>
 *
 * Example:
 * ["ACRE_WS38_ID_1", "getCurrentChannelData", [], _radioData, false] call acre_sys_ws38_fnc_getCurrentChannelData
 *
 * Public: No
 */

params ["", "", "", "_radioData", ""];

private _return = HASH_CREATE;

HASH_SET(_return, "mode", HASH_GET(_radioData, "mode"));
HASH_SET(_return, "frequencyTX", HASH_GET(_radioData, "frequencyTX"));
HASH_SET(_return, "frequencyRX", HASH_GET(_radioData, "frequencyRX"));
if (HASH_GET(_radioData, "powerSource") == "VAU") then {
    HASH_SET(_return, "power", HASH_GET(_radioData, "power")); // currently the power stays the same
} else {
    HASH_SET(_return, "power", HASH_GET(_radioData, "power"));
};
HASH_SET(_return, "CTCSSTx", HASH_GET(_radioData, "CTCSSTx"));
HASH_SET(_return, "CTCSSRx", HASH_GET(_radioData, "CTCSSRx"));
HASH_SET(_return, "modulation", HASH_GET(_radioData, "modulation"));
HASH_SET(_return, "encryption", HASH_GET(_radioData, "encryption"));
HASH_SET(_return, "TEK", HASH_GET(_radioData, "TEK"));
HASH_SET(_return, "trafficRate", HASH_GET(_radioData, "trafficRate"));
HASH_SET(_return, "syncLength", HASH_GET(_radioData, "syncLength"));

_return
