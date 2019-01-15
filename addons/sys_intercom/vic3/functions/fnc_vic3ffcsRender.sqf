#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Renders the VIC3 FFCS when opened.
 *
 * Arguments:
 * 0: Display identifier <NUMBER>
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * [DisplayID] call acre_sys_intercom_fnc_vic3ffcsRender
 *
 * Public: No
 */

#define INTERCOM_CTRL(var1) (_display displayCtrl var1)
params ["_display"];

true
