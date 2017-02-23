/*
 * Author: ACRE2Team
 * Reserves a unique ID for a radio baseclass and returns it.
 *
 * Arguments:
 * 0: Base class <STRING>
 *
 * Return Value:
 * Unique id for classname (-1 is returned if no more unique Ids are left) <NUMBER>
 *
 * Example:
 * ["acre_prc343"] call acre_sys_server_fnc_getRadioId
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_class"];

_class = toLower _class;

GVAR(radioIdMap) params ["_baseTypes","_radioIds"];

private _mapIndex = _baseTypes find (toLower _class);

if (_mapIndex == -1) then {
    _mapIndex = _baseTypes pushBack (toLower _class);
    _radioIds set [_mapIndex, []];
};

private _takenIds = _radioIds select _mapIndex;

private _ret = -1;
for "_i" from 1 to 512 do {
    if (!(_i in _takenIds)) exitWith {
        _ret = _i;
        _takenIds pushBack _ret;
    };
};

_ret
