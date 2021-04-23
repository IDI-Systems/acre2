#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Close radio GUI. Event raised by onUnload (BF888S_RadioDialog).
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "closeGui" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "closeGui", [], [], false] call acre_sys_bf888s_fnc_closeGui
 *
 * Public: No
 */

params ["_radioId", "", "", "", ""];

[_radioId, false] call EFUNC(sys_radio,setRadioOpenState);

GVAR(currentRadioId) = -1;

true
