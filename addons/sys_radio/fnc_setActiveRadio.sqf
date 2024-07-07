#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the active radio.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * Active radio updated <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_setActiveRadio
 *
 * Public: No
 */

TRACE_1("SETTING ACTIVE RADIO",_this);

ACRE_ACTIVE_RADIO = _this select 0;

true
