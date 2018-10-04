#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Determines whether the unit can be heard by the local player or not.
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * 0 for false, 1 for true <NUMBER>
 *
 * Example:
 * [player] call acre_sys_core_fnc_getAlive
 *
 * Public: No
 */

params ["_unit"];

private _ret = 0;
if (_unit isEqualTo acre_player) then {
    if (ACRE_IS_SPECTATOR || alive acre_player) then {
        _ret = 1;
    };
} else {
    if (!isNull _unit) then {
        private _ts3id = GET_TS3ID(_unit);
        if ((alive _unit && {!(_ts3id in ACRE_SPECTATORS_LIST)}) || {(ACRE_IS_SPECTATOR && {!ACRE_MUTE_SPECTATORS} && {_ts3id in ACRE_SPECTATORS_LIST})}) then {
            _ret = 1;
        };
    };
};

_ret
