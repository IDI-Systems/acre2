/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_className", "_position", "_direction", "_volume", "_isWorld"];

_volume = (_volume max 0) min 1;
["playLoadedSound", [_className, _position, _direction, _volume, _isWorld]] call EFUNC(sys_rpc,callRemoteProcedure);
