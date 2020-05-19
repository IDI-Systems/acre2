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
 * [ARGUMENTS] call acre_sys_data_fnc_stateEvent
 *
 * Public: No
 */

private _params = ["CfgAcreStateInterface"];
_params append _this;
/*_params set[1, _this select 0];
_params set[2, _this select 1];
if ((count _this) == 3) then {
    _params set[3, _this select 2];
};*/
// diag_log text format["ACRE STATE EVENT: %1", _params];
_params call FUNC(acreEvent)
