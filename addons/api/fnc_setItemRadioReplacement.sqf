#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * DEPRECATED! Replaced by CBA Setting.
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

ACRE_DEPRECATED(QFUNC(setItemRadioReplacement),"2.12","CBA Setting")

params ["_radioType"];

[QEGVAR(sys_radio,defaultRadio), _radioType, 1, "mission"] call CBA_settings_fnc_set;

true
