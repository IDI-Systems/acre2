#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the unique identity of the current channel since the WS38 has multiple blocks.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 *
 * Return Value:
 * Identity of the current channel <NUMBER>
 *
 * Example:
 * ["ACRE_WS38_ID_1"] call acre_sys_ws38_fnc_getCurrentChannelInternal
 *
 * Public: No
 */

params ["_radioId", "", "", "", ""];

private _currentChannelId = [_radioId, "getState", "currentChannel"] call EFUNC(sys_data,dataEvent);
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
