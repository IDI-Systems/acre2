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
 * [ARGUMENTS] call acre_sys_data_fnc_physicalEvent
 *
 * Public: No
 */

// _this = [radioId, eventType, data]
private _params = ["CfgAcrePhysicalInterface"];
_params append _this;

/*_params set[1, _this select 0];
_params set[2, _this select 1];
if ((count _this) == 3) then {
    _params set[3, _this select 2];
};*/
_params call FUNC(acreEvent);
