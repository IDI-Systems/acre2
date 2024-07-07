#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns ASL position of the radio's containing object.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * ASL Position <ARRAY>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioPos
 *
 * Public: No
 */

params ["_class"];

private _ret = [0,0,0];
if (HASH_HASKEY(EGVAR(sys_server,objectIdRelationTable),_class)) then {
    _ret = getPosASL (HASH_GET(EGVAR(sys_server,objectIdRelationTable),_class) select 0);
};
_ret;
