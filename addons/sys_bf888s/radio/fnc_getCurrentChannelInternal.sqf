#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the unique identity of the current channel.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Identity of the current channel <NUMBER>
 *
 * Example:
 * ["ACRE_BF888S_ID_1"] call acre_sys_bf888s_fnc_getCurrentChannelInternal
 *
 * Public: No
 */

params ["_radioId", "", "", "", ""];

private _currentChannelId = [_radioId, "getState", "currentChannel"] call EFUNC(sys_data,dataEvent);
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
