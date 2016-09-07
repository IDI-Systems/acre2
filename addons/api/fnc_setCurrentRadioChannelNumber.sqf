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

params["_channelNumber"];

if( !(_channelNumber isEqualType 0)) exitWith { false };

private _radioId = [] call FUNC(getCurrentRadio);
if(_radioId == "") exitWith { false };

[_radioId, _channelNumber] call FUNC(setRadioChannel);

true
