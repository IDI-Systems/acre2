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
 * [ARGUMENTS] call acre_sys_prc152_fnc_renderMenu
 *
 * Public: No
 */

TRACE_1("renderMenu", _this);
params ["_menu", "_callerMenu"]; // the menu to render is passed

[] call FUNC(clearDisplay);
/*
if (!([_menu] call FUNC(verifyIsMenu)) ) exitWith {
    _menu = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
    [_menu] call FUNC(changeMenu);
};
*/
private _menuId = MENU_ID(_menu);
if (isNil "_menuId") then {
    SET_STATE("currentRenderMenu", _menu);
} else {
    SET_STATE("currentRenderMenu", _menuId);
};

[_menu] call FUNC(callRenderFunctor);

if (MENU_TYPE(_menu) >= MENU_ACTION_NONE ) then {
    switch ( MENU_TYPE(_menu) ) do {
        // Its not a full submenu, but it references another embedded submenu. Render it
        case MENU_ACTION_SUBMENU: {
            TRACE_1("MENU_ACTION_SUBMENU", MENU_SUBMENUS_ITEM(_menu,0));
            [MENU_SUBMENUS_ITEM(_menu,0), _callerMenu] call FUNC(changeMenu);
        };
        case MENU_ACTION_CODE: {
            [_menu, _callerMenu] call MENU_SUBMENUS_ITEM(_menu, 0);
        };
        default {
            WARNING("Unhandled menu action type!");
        };
    };
} else {
    switch MENU_TYPE(_menu) do {
        case MENUTYPE_DISPLAY: {
            [_menu, _callerMenu] call FUNC(renderMenu_Display);
        };
        case MENUTYPE_STATIC: {
            [_menu, _callerMenu] call FUNC(renderMenu_Static);
        };
        case MENUTYPE_LIST: {
            [_menu, _callerMenu] call FUNC(renderMenu_List);
        };
        case MENUTYPE_ACTIONSERIES: {
            [_menu, _callerMenu] call FUNC(renderMenu_ActionSeries);
        };
        /*
            Data Entry Menus
        */
        case MENUTYPE_SELECTION: {
            [_menu, _callerMenu] call FUNC(renderMenu_Selection);
        };
        case MENUTYPE_ALPHANUMERIC: {
            [_menu, _callerMenu] call FUNC(renderMenu_Alphanumeric);
        };
        case MENUTYPE_NUMBER: {
            [_menu, _callerMenu] call FUNC(renderMenu_Number);
        };
        case MENUTYPE_FREQUENCY: {
            [_menu, _callerMenu] call FUNC(renderMenu_Frequency);
        };

        default {
            TRACE_1("!!! INVALID MENU SPECIFIED", "");
        };
    };
};

// We need to always call render to make sure knobs, icons and other things get moved around correctly
[] call FUNC(render);
