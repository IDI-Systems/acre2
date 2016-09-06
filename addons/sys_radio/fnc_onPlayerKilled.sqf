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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"
TRACE_1("", _this);

if((_this select 0) == acre_player) then {
    LOG("acre_player died. resetting all radio info");
    {
        private ["_foo", "_bar", "_radioName"];
        _radioName = _x;
        acre_player setVariable [_radioName, nil, false];
    } foreach GVAR(currentRadioList);
    GVAR(currentRadioList) = [];

    [""] call FUNC(setActiveRadio);
};
