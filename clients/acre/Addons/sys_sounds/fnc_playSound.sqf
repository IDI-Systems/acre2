//fnc_playSound.sqf
 
#include "script_component.hpp"

params ["_className", "_position", "_direction", "_volume", "_isWorld"];

_volume = (_volume max 0) min 1;
["playLoadedSound", [_className, _position, _direction, _volume, _isWorld]] call EFUNC(sys_rpc,callRemoteProcedure);
