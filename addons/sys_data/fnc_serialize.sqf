#include "script_component.hpp"
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

private ["_ret"];
if (IS_HASH(_this)) then {
    _ret = _this call FUNC(_hashSerialize);
} else {
    if (IS_ARRAY(_this)) then {
        _ret = _this call FUNC(_arraySerialize);
    } else {
        _ret = _this;
    };
};
_ret;
