#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc148_fnc_defaultButtonHandler
 *
 * Public: No
 */

params ["_button"];

if (_button == "ENT") then {
    _this call FUNC(handleMenuButtonEnter);
};
if (_button == "UP") then {
    [1, _this] call FUNC(handleMenuDirButton);
};
if (_button == "DOWN") then {
    [-1, _this] call FUNC(handleMenuDirButton);
};
if (_button == "ESC") then {
    _this call FUNC(handleEscButton);
    if (GET_STATE("currentState") == "GroupDisplay") then {
        [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
    };
};
if (_button == "GR") then {
    // SET_PAGE_INDEX(0);
    // SET_MENU_INDEX(0);
    SET_STATE("currentEditEntry",GET_STATE_DEF("currentGroup",0));
    [GVAR(currentRadioId), "GroupDisplay", 0, 0, 0, 0] call FUNC(changeState);
    // SET_STATE("editEntry",true);
};
if (_button == "MODE") then {
    _this call FUNC(handleModeButton);
};
[GET_DISPLAY] call FUNC(render);
