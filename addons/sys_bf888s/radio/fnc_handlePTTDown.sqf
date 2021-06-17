#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function called when PTT key is pressed. The most important aspect is setting the PTTDown flag
 * of the radio to true.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "handlePTTDown" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "handlePTTDown", [], [], false] call acre_sys_BF888S_fnc_handlePTTDown
 *
 * Public: No
 */

params ["_radioId", "", "", "", ""];

if (!([_radioId] call EFUNC(sys_radio,canUnitTransmit))) exitWith {false};

private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericBeep", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId, "PTTDown", true);
true
