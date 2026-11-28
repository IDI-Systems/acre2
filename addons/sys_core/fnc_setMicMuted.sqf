#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Mutes or unmutes our microphone (the mute keybind). Nothing is transmitted while muted, push-to-talk
 * included. The state is published on our unit so other players see it in the Players screen.
 *
 * Arguments:
 * 0: Muted <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_core_fnc_setMicMuted
 *
 * Public: No
 */

params [["_muted", false, [false]]];

if (_muted isEqualTo GVAR(micMuted)) exitWith {};
GVAR(micMuted) = _muted;

{
    if (!isNull _x) then {
        _x setVariable [QGVAR(micMuted), _muted, true];
    };
} forEach ([player, acre_player] arrayIntersect [player, acre_player]);

// aliveMonitor tells the extension on its next frame.
GVAR(oldMute) = -1;

["acre_micMuted", [_muted]] call CBA_fnc_localEvent;
