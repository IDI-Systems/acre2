#include "script_component.hpp"
/*
 * Author: PabstMirror
 * Shows arsenal stats
 *
 * Arguments:
 * 0: Stats Array of config strings <ARRAY>
 * 1: Radio Cfg <CONFIG>
 *
 * Return Value:
 * <STRING>
 *
 * Example:
 * [["acre_arsenalStats_externalSpeaker"], configFile >> "CfgWeapons" >> "ACRE_PRC117F"] call acre_ace_interact_fnc_arsenalStats_externalSpeaker
 *
 * Public: No
 */
 
params ["_statsArray", "_itemCfg"];

private _val = getNumber (_itemCfg >> (_statsArray select 0));
if (_val > 0) then { localize "str_lib_info_yes" } else { localize "str_lib_info_no" }
