/*
 * Author: ACRE2Team
 * The amount of time in seconds to delay releasing the radio PTT key. 
 *
 * Arguments:
 * 0: Delay in seconds between 0 and 1. <NUMBER>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _delay = [0.2] call acre_api_fnc_setPTTDelay;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_var"];

if(!( _var isEqualType "SCALAR")) exitWith { false };

if(_var > 1 || _var < 0) exitWith { false };

ACRE_PTT_RELEASE_DELAY = _var;

true
