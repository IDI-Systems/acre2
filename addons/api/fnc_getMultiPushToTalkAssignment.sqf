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

//Emulate behaviour of the handleMultiPttKeyPress algorithm

private _radioLists = [+ ACRE_ASSIGNED_PTT_RADIOS, [] call EFUNC(sys_data,getPlayerRadioList)] call EFUNC(sys_data,sortRadioList);


private _returnValue = (_radioLists select 1);

_returnValue
