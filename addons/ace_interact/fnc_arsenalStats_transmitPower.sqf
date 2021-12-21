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
 * [["...power"], configFile >> "CfgWeapons" >> "ACRE_PRC117F"] call acre_ace_interact_fnc_arsenalStats_transmitPower
 *
 * Public: No
 */

params ["_statsArray", "_itemCfg"];

private _power = getNumber (_itemCfg >> _statsArray select 0); //in milliwatts

if (_power == 0) exitWith {"?"};
if (_power >= 1e3) then { format ["%1W", _power/1000] } else { format ["%1mW",_power] }
