#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns currently visible display of registered displays by acre_sys_list_fnc_addDisplaySupport.
 * If multiple displays are visible (except mission display), it returns the first registered one.
 * Returns mission display if none other found.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Active Display ID <NUMBER>
 *
 * Example:
 * private _displayId = call acre_sys_list_fnc_getActiveDisplay
 *
 * Public: No
 */

private _index = GVAR(hintDisplays) findIf {!isNull (findDisplay _x)};

if (_index == -1) exitWith { IDD_MISSION };

GVAR(hintDisplays) select _index
