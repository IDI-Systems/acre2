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

#include "\idi\acre\addons\sys_prc148\script_component.hpp"

DFUNC(AccessDeniedState) = {
    [GVAR(currentRadioId), "AccessDeniedDisplay"] call FUNC(changeState);
};

DFUNC(AccessDeniedDisplay_Render) = {
    params["_display"];
    [_display, BIG_LINE_1, "PROGRAMMING", CENTER_ALIGN] call FUNC(displayLine);
    [_display, BIG_LINE_2, "ACCESS DENIED", CENTER_ALIGN] call FUNC(displayLine);
    [_display, BIG_LINE_4, "PRESS ESC TO EXIT", CENTER_ALIGN] call FUNC(displayLine);
};

DFUNC(AccessDeniedDisplay_ESC) = {
    //acre_player sideChat format["fff"];
    _lastState = ["getState", "lastState"] call GUI_DATA_EVENT;
    //acre_player sideChat format["ls: %1", _lastState];
    [GVAR(currentRadioId), _lastState select 0, _lastState select 1, _lastState select 2] call FUNC(changeState);
};

DFUNC(AccessDeniedDisplay_ENT) = { };
DFUNC(AccessDeniedDisplay_GR) = { };
DFUNC(AccessDeniedDisplay_MODE) = { };
DFUNC(AccessDeniedDisplay_DOWN) = { };
DFUNC(AccessDeniedDisplay_UP) = { };
DFUNC(AccessDeniedDisplay_ALT) = { };
