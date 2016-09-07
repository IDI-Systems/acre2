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
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioId"];

if(!(_radioId isEqualType "")) exitWith { -1 };

private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);

if(isNil "_channelNumber") exitWith { nil };
_channelNumber = _channelNumber + 1;
_channelNumber
