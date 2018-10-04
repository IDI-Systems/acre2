#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This is the callback function for recieving the event "handleLoadedSound" from teamspeak. It just ensures a sound is marked as loaded to prevent it from being loaded again. It will also call the callback function specified in the loadSound function if one exists.
 *
 * Arguments:
 * 0: Radio classname <STRING>
 * 1: Load code (1 represents a successful load) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Acre_GenericClick",1] call acre_sys_sounds_fnc_handleLoadedSound
 *
 * Public: No
 */

params ["_id","_okN"];

_okN = parseNumber _okN;

private _ok = false;

TRACE_2("Sound File Loaded", _id, _ok);
if (_okN == 1) then {
    _ok = true;
    GVAR(loadedSounds) pushBack _id;
};

if (HASH_HASKEY(GVAR(callBacks), _id)) then {
    private _func = HASH_GET(GVAR(callBacks), _id);
    [_id, _ok] call CALLSTACK_NAMED(_func, _id);
};
