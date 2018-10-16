#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Plays a loaded sound from teamspeak.
 *
 * Arguments:
 * 0: Sound classname <STRING> - Same classname as used in the loadSound function.
 * 1: Relative position <ARRAY>
 * 2: Direction of sound <ARRAY>
 * 3: Volume <NUMBER>
 * 4: World <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call acre_sys_sounds_fnc_playSound
 *
 * Public: No
 */

params ["_className", "_position", "_direction", "_volume", "_isWorld"];

_volume = (_volume max 0) min 1;
["playLoadedSound", [_className, _position, _direction, _volume, _isWorld]] call EFUNC(sys_rpc,callRemoteProcedure);
