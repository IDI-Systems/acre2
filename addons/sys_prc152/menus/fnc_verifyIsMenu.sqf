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
 * [ARGUMENTS] call acre_sys_prc152_fnc_verifyIsMenu
 *
 * Public: No
 */

/* just in case we get a bad menu or a bad value, lets verify its a valid menu! */

params ["_menu"];

// Its an array with 5 variables at least
if (typeName _menu != "ARRAY") exitWith { false };
if ((count _menu) < 5) exitWith { false };

// Verify the first 3 values are strings
private _menuId = MENU_ID(_menu);
if (!isNil "_menuId" && {(typeName _menuId) != "STRING"}) exitWith { false };

if ((typeName (_menu select 1) != "STRING") || {(typeName (_menu select 2) != "STRING")}) exitWith { false };

private _subMenus = MENU_SUBMENUS(_menu);
// Verify subitems is an array or at least nil
if (!isNil "_subMenus" && {(typeName _menuId) != "ARRAY"}) exitWith { false };

true
