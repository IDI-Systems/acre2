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
 * [ARGUMENTS] call acre_sys_core_fnc_formatNumber;
 *
 * Public: No
 */
#include "script_component.hpp"

private _ext = abs _this - (floor abs _this);
private _str = "";

for "_i" from 1 to 24 do {
    private _d = floor (_ext*10);
    _str = _str + (str _d);
    _ext = (_ext*10)-_d;
};
format["%1%2.%3", ["","-"] select (_this < 0), (floor (abs _this)), _str];
