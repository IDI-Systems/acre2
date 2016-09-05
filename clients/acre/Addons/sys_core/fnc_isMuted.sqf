//fnc_isMuted.sqf
#include "script_component.hpp"

params["_player"];

// if(_player in GVAR(muting)) exitWith {
    // true
// };

private _ret = false;

if(!isNull _player) then {
    private _alive = [_player] call FUNC(getAlive);
    if(_alive != 1) then {
        _ret = true;
    };
};

_ret
