#include "script_component.hpp"
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

params [
    ["_delay", 0, [0]]
];

if (!( _delay isEqualType "SCALAR")) exitWith { false };

if (_delay > 1 || _delay < 0) exitWith { false };

ACRE_PTT_RELEASE_DELAY = _delay;

true
