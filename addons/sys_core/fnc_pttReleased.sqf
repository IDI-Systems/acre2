#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Runs a push-to-talk release after ACRE_PTT_RELEASE_DELAY (so the last word isn't cut off),
 * unless the same PTT is pressed again meanwhile (acre_sys_core_fnc_pttPressed).
 *
 * Arguments:
 * 0: PTT name <STRING>
 * 1: Release code <CODE>
 * 2: Arguments for the code <ANY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["intercom", {["intercom"] call acre_sys_core_fnc_stopTransmission}] call acre_sys_core_fnc_pttReleased
 *
 * Public: No
 */

params ["_name", "_code", ["_args", []]];

private _presses = GVAR(pttPresses) getOrDefault [_name, 0];
[{
    params ["_name", "_presses", "_code", "_args"];
    if ((GVAR(pttPresses) getOrDefault [_name, 0]) == _presses) then {
        _args call _code;
    };
}, [_name, _presses, _code, _args], ACRE_PTT_RELEASE_DELAY] call CBA_fnc_waitAndExecute;
