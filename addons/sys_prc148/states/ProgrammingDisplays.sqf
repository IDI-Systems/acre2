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

DFUNC(ProgrammingDisplay_Render) = {
    params["_display"];

    GVAR(currentMenu) =
    [
        [
            ["ZEROIZE", "ZEROIZE", BIG_LINE_1, [2, 12], MENU_TYPE_MENU, FUNC(AccessDeniedState)],
            ["KEYFILL", "KEYFILL", BIG_LINE_2, [2, 12], MENU_TYPE_MENU, FUNC(AccessDeniedState)],
            ["PROGRAM", "PROGRAM", BIG_LINE_3, [2, 12], MENU_TYPE_MENU, { [GVAR(currentRadioId), "ProgramDisplay"] call FUNC(changeState); }],
            ["STATUS", "STATUS", BIG_LINE_4, [2, 12], MENU_TYPE_MENU, FUNC(AccessDeniedState)]
        ],
        [
            ["MAINTENANCE", "MAINTENANCE", BIG_LINE_1, [2, 12], MENU_TYPE_MENU, FUNC(AccessDeniedState)]
        ]
    ];

    [_display, GVAR(currentMenu)] call FUNC(showMenu);
};

DFUNC(ProgrammingDisplay_ESC) = {
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};
