#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles dialog closed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_radio_fnc_onDialogClose
 *
 * Public: No
 */

LOG("closed?");
GVAR(currentRadioDialog) = nil;
