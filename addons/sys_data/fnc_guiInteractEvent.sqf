/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private _params = ["CfgAcreInteractInterface", acre_sys_radio_currentRadioDialog];
//_params pushBack acre_sys_radio_currentRadioDialog;
_params append _this;
_params call FUNC(acreEvent);
