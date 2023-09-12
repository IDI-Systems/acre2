#include "..\script_component.hpp"
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
 * ["ACRE_PRC343_ID_1", "getChannelDescription", [], [], false] call acre_sys_prc343_fnc_getChannelDescription
 *
 * Public: No
 */

params ["_radioId", "",  "", "", ""];

private _currentAbsChannel = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
private _currentBlock = floor (_currentAbsChannel / 16);
private _currentChannel = _currentAbsChannel - _currentBlock*16;

private _description = format ["Block %1 - Channel %2", _currentBlock + 1, _currentChannel + 1];

_description
