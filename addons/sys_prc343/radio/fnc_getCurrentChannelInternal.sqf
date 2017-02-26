/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannelInternal" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_getCurrentChannelInternal
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "", "", "", ""];

private _currentChannelId = [_radioId, "getState", "currentChannel"] call EFUNC(sys_data,dataEvent);
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
