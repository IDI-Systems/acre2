#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Plays a loaded sound from VOIP solution.
 *
 * Arguments:
 * 0: Sound classname <STRING> - Same classname as used in the loadSound function.
 * 1: Relative position <ARRAY>
 * 2: Direction of sound <ARRAY>
 * 3: Volume <NUMBER>
 * 4: World <BOOL>
 * 5: Scale with Global Volume <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call acre_sys_sounds_fnc_playSound
 * ["Acre_GodPingOn", [0,0,0], [0,0,0], 1, false, false] call acre_sys_sounds_fnc_playSound
 *
 * Public: No
 */

params ["_className", "_position", "_direction", "_volume", "_isWorld", ["_scaleGlobalVolume", true]];

_volume = (_volume max 0) min 1;

if (_scaleGlobalVolume) then {
    _volume = _volume * EGVAR(sys_core,globalVolume);
};

["playLoadedSound", [_className, _position, _direction, _volume, _isWorld]] call EFUNC(sys_rpc,callRemoteProcedure);
