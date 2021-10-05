#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function called when starting a transmission. For the BF-888S it does nothing.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "handleBeginTransmission" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "handleBeginTransmission", [], [], false] call acre_sys_bf888s_fnc_handleBeginTransmission
 *
 * Public: No
 */

true
