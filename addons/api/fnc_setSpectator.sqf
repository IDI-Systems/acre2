/*
 * Author: ACRE2Team
 * Pass true or false to set the unit as a “spectator” or not. This will override current alive status, and join the player to dead channel regardless.
 *
 * Arguments:
 * 0: true or false on whether the unit should locally be considered a spectator <BOOLEAN>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _ret = [true] call acre_api_fnc_setSpectator;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

params ["_spectVariable"];

if(!IS_BOOL(_spectVariable)) exitWith { false };
if(_spectVariable) then {
    [] call EFUNC(sys_core,spectatorOn);
} else {
    [] call EFUNC(sys_core,spectatorOff);
};
true
