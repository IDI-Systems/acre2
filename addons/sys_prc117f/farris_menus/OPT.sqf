/*
 * Author: AUTHOR
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

GVAR(OPT) = ["OPT", "OPT", "",
    MENUTYPE_LIST,
    [
        [nil, "NOT COMPLETED", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(OPT)] call FUNC(createMenu);
