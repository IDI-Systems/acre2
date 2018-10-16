#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the radios within a certain distance.
 *
 * Arguments:
 * 0: Position in ASL <ARRAY>
 * 1: Radius <NUMBER>
 *
 * Return Value:
 * Array of near radios <ARRAY>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_nearRadioPos
 *
 * Public: No
 */

params ["_position", "_radius"];

private _return = [];
{
    private _radioId = _x;
    private _object = HASH_GET(EGVAR(sys_server,objectIdRelationTable), _radioId);

    if ((getPosASL (_object select 0)) distance _position <= _radius) then {
        PUSH(_return, _radioId);
    };
} forEach HASH_KEYS(EGVAR(sys_server,objectIdRelationTable));

_return;
