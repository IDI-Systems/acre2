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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_changeMenu
 *
 * Public: No
 */

TRACE_1("changeMenu ENTER", "");

params ["_newMenu"];


// clear menu data
SET_STATE("menuSelection", 0);

//
//
private _oldMenu = GET_STATE("currentMenu");
SCRATCH_SET(GVAR(currentRadioId),"menuEntry",true);
// Set the state
if (!isNil "_oldMenu") then {
    if (_oldMenu isEqualType "") then {
        _oldMenu = HASH_GET(GVAR(Menus), _oldMenu);
    };
    if (!isNil "_oldMenu") then {
        TRACE_1("changeMenu calling complete", MENU_DISPLAYNAME(_oldMenu));
        [_oldMenu] call FUNC(callCompleteFunctor);

        private _menuId = MENU_ID(_oldMenu);
        if (!isNil "_menuId") then { SET_STATE("lastMenu", _menuId); } else { SET_STATE("lastMenu", _oldMenu); };
    };
};

// Set the state
if (_newMenu isEqualType "") then {
    if (_newMenu == "HOME") then {
        _newMenu = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
    };
    if (_newMenu isEqualType "") then {
        _newMenu = HASH_GET(GVAR(Menus), _newMenu);
    };
};
TRACE_1("CHANGING MENU", _newMenu);
if (isNil "_newMenu") then {
    // Fall back worst case on the VULOS home if we fucked up royally somehow
    _newMenu = GVAR(VULOSHOME);
};

private _menuId = MENU_ID(_newMenu);
if (!isNil "_menuId") then { SET_STATE("currentMenu", _menuId); } else { SET_STATE("currentMenu", _newMenu); };
[_newMenu] call FUNC(callEntryFunctor);
[_newMenu, _oldMenu] call FUNC(renderMenu);

SCRATCH_SET(GVAR(currentRadioId), "menuEntry", false);
