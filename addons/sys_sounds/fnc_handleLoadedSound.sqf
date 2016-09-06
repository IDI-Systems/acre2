/*
 * Author: ACRE2Team
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

params["_id","_okN"];
_okN = parseNumber _okN;

private _ok = false;
TRACE_2("Sound File Loaded", _id, _ok);
if(_okN == 1) then {
    _ok = true;
    PUSH(GVAR(loadedSounds, _id));
};
if(HASH_HASKEY(GVAR(callBacks), _id)) then {
    private _func = HASH_GET(GVAR(callBacks), _id);
    [_id, _ok] call CALLSTACK_NAMED(_func, _id);
};
