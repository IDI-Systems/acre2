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
 * 0: Active Display <DISPLAY>
 * 1: Active Display ID <NUMBER>
 *
 * Example:
 * _displayData = call acre_sys_list_fnc_getActiveDisplay
 *
 * Public: No
 */

private _displayOverride = uiNamespace getVariable [QGVAR(hintDisplayOverride), displayNull];
if (!isNull _displayOverride) exitWith {
    [_displayOverride, -1]
};

private _index = GVAR(hintDisplays) findIf {!isNull (findDisplay _x)};

private _displayId = IDD_MISSION;
if (_index != -1) then {
    _displayId = GVAR(hintDisplays) select _index;
};

[findDisplay _displayId, _displayId]
