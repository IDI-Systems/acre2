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

private["_radioId", "_channelNumber"];
_radioId = [] call FUNC(getCurrentRadio);
if(_radioId == "") exitWith { -1 };

_channelNumber = [_radioId] call FUNC(getRadioChannel);

if(isNil "_channelNumber") exitWith { -1 };
_channelNumber = _channelNumber + 1;
_channelNumber
