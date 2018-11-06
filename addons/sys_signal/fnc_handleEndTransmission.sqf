#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function called when radio transmission is finished (see sys_data/CfgAcreInterface.hpp).
 *
 * Arguments:
 * 0: Receiving radio ID <STRING> (Unused)
 * 1: Event (-> "handleEndTransmission") <STRING> (Unused)
 * 2: Radio ID with transmitting radio Id <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC152_ID_1", "handleEndTransmission", "ACRE_PRC152_ID_2"] call acre_sys_signal_fnc_handleEndTransmission
 *
 * Public: No
 */

params ["", "", "_data"];
_data params ["_transmitterClass"];

missionNamespace setVariable [_transmitterClass + "_running_count", 0];
missionNamespace setVariable [_transmitterClass + "_best_signal", -992];
missionNamespace setVariable [_transmitterClass + "_best_ant", ""];

nil
