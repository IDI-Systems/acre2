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
private ["_currentChannelId"];
TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!GET CURRENT CHANNEL", _this);

params ["_radioId", "_event", "_eventData", "_radioData"];

_currentChannelId = HASH_GET(_radioData,"currentChannel");
if(isNil "_currentChannelId") then {
    _currentChannelId = [0,0];
};

_currentChannelId
