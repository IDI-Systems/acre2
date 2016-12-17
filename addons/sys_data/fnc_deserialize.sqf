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
 * [ARGUMENTS] call acre_sys_data_fnc_serialize;
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_ret"];
if (IS_SERIALIZEDHASH(_this)) then {
    _ret = _this call FUNC(_hashDeserialize);
} else {
    if (IS_ARRAY(_this)) then {
        _ret = _this call FUNC(_arrayDeserialize);
    } else {
        _ret = _this;
    };
};
_ret;
