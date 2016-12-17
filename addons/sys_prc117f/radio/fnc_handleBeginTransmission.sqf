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

params ["_radioId", "_eventKind", "_eventData"];

if (_radioId isEqualTo GVAR(currentRadioId)) then {
    // If display is open
    private _currentMenu = GET_STATE_DEF("currentMenu", "");
    if (_currentMenu isEqualType "") then {
        if (_currentMenu != "") then {
            private _tmpMenu = HASH_GET(GVAR(Menus), _currentMenu);
            if (!isNil "_tmpMenu") then {
                _currentMenu = _tmpMenu;
            };
        };
    };
    
    [_currentMenu, _currentMenu] call FUNC(renderMenu);
};

true;
