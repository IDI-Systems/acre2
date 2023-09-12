#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_getCurrentChannel
 *
 * Public: No
 */

TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!GET CURRENT CHANNEL", _this);

params ["", "", "", "_radioData"];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
