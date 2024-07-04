#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the radio subobject
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Radio subobject <OBJECT>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioSubObject
 *
 * Public: No
 */

params ["_class"];

private _ret = nil;
if (HASH_HASKEY(EGVAR(sys_server,objectIdRelationTable),_class)) then {
    _ret = (HASH_GET(EGVAR(sys_server,objectIdRelationTable),_class) select 1);
};
_ret;
