#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Set the radio type to replace "ItemRadio" in unit inventories. By default this is the "ACRE_PRC343"
 *
 * Arguments:
 * 0: Radio base type <STRING>
 *
 * Return Value:
 * Success <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC148"] call acre_api_fnc_setItemRadioReplacement;
 *
 * Public: Yes
 */

params ["_radioType"];

EGVAR(sys_radio,defaultItemRadioType) = _radioType;

true
