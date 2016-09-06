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

params["_unit"];

private _ret = 0;
if(_unit == acre_player) then {
    if(ACRE_IS_SPECTATOR || alive acre_player) then {
        _ret = 1;
    };
} else {
    if(!isNull _unit) then {
        _ts3id = GET_TS3ID(_unit);
        if((alive _unit && !(_ts3id in ACRE_SPECTATORS_LIST)) || (_ts3id in ACRE_SPECTATORS_LIST && ACRE_IS_SPECTATOR && !ACRE_MUTE_SPECTATORS)) then {
            _ret = 1;
        };
    };
};

_ret
