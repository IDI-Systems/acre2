#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the description of the currently selected channel. Used in the transmission hint.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "getChannelDescription" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Description of the channel in the form "Block x - Channel y" <STRING>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getChannelDescription", [], [], false] call acre_sys_bf888s_fnc_getChannelDescription
 *
 * Public: No
 */

params ["_radioId", "",  "", "", ""];

private _currentAbsChannel = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
private _currentChannel = _currentAbsChannel;

private _description = format ["Channel %1",_currentChannel + 1];

_description
