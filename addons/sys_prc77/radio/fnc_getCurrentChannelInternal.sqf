#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the unique identity of the current channel.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannelInternal" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Identity of the current channel <NUMBER>
 *
 * Example:
 * ["ACRE_PRC77_ID_1"] call acre_sys_prc77_fnc_getCurrentChannelInternal
 *
 * Public: No
 */

TRACE_1("GET CURRENT CHANNEL",_this);

params ["", "", "", "_radioData", ""];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = [0,0];
};

_currentChannelId
