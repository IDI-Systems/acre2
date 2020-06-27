#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_interactEvent
 *
 * Public: No
 */

private _params = ["CfgAcreInteractInterface"];
_params append _this;
_params call FUNC(acreEvent);
