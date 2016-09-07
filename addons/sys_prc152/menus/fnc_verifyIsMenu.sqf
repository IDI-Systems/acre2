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

private["_ret", "_subMenus", "_menuId"];

/* just in case we get a bad menu or a bad value, lets verify its a valid menu! */
_ret = true;

params["_menu"];

// Its an array with 5 variables at least
if(typeName _menu != "ARRAY") exitWith { _ret = false; false };
if((count _menu) < 5) exitWith { _ret = false; false };

// Verify the first 3 values are strings
_menuId = MENU_ID(_menu);
if(!isNil "_menuId") then {
    if((typeName _menuId) != "STRING") exitWith { _ret = false; false };
};
if( (typeName (_menu select 1) != "STRING" ) ||
(typeName (_menu select 2) != "STRING" ) ) exitWith {
    _ret = false; false
};

_subMenus = MENU_SUBMENUS(_menu);
// Verify subitems is an array or at least nil
if(!isNil "_subMenus") then {
    if((typeName _menuId) != "ARRAY") exitWith { _ret = false; false };
};



_ret
