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
 * [ARGUMENTS] call acre_sys_prc152_fnc_onButtonPress
 *
 * Public: No
 */

TRACE_1("enter", _this);

//["Acre_GenericClick", [0,0,0], [0,0,0], 0.2, false] call EFUNC(sys_sounds,playSound);

#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(buttonPress);
#endif

private _control = ctrlIDC (_this select 1);

if (_control != 222 && {_control != (99902 + 116)} && {_control != (99902 + 117)}) then {
    [_this select 0] call FUNC(toggleButtonPressDown);
} else {
    ["Acre_GenericClick", [0,0,0], [0,0,0], 0.2, false] call EFUNC(sys_sounds,playSound);
};


private _currentMenu = GET_STATE_DEF("currentMenu", "");
TRACE_1("Got current menu", _currentMenu);

if (isNil "_currentMenu") exitWith {
    WARNING("Button press without a selected menu item!");
    true
};

if (_currentMenu isEqualType "" && {_currentMenu != ""}) then {
    private _tmpMenu = HASH_GET(GVAR(Menus), _currentMenu);
    if (!isNil "_tmpMenu") then {
        _currentMenu = _tmpMenu;
    };
};

if (_currentMenu isEqualType []) then {
    TRACE_1("Searching for key handler", MENU_ID(_currentMenu));
    // First, call our global key handler
    // We only call it if we had a valid menu, because it means the radio is active. Right!?
    // If it returns true, it means it consumed it and we dont move further

    // Call the menu's button handler if it has one.
    // If it returns true, it means it consumed it and we dont move further
    // nil or false, continue.
    private _ret = [_currentMenu, _this] call FUNC(callButtonFunctor);
    if (!_ret) then {
        // Now call the menus type handler
        TRACE_1("onButtonPress","");
        switch MENU_TYPE(_currentMenu) do {
            case MENUTYPE_DISPLAY: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Display);
            };
            case MENUTYPE_STATIC: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Static);
            };
            case MENUTYPE_LIST: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_List);
            };
            case MENUTYPE_ACTIONSERIES: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_ActionSeries);
            };
            case MENUTYPE_SELECTION: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Selection);
            };
            case MENUTYPE_NUMBER: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Number);
            };
            case MENUTYPE_FREQUENCY: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Frequency);
            };
            case MENUTYPE_ALPHANUMERIC: {
                _ret = [_currentMenu, _this] call FUNC(onButtonPress_Alphanumeric);
            };
            default {
                diag_log text format["!!! INVALID MENU SPECIFIED"];
            };
        };

        if (isNil "_ret") then { _ret = false; };

        if (!_ret) then {
            //TRACE_2("", _currentMenu, _this);
            _ret = [_currentMenu, _this] call FUNC(defaultButtonPress);
            if (!_ret) then {
                private _newId = nil;
                private _newMenu = GET_STATE_DEF("currentMenu", GVAR(VULOSHOME));
                private _oldId = MENU_ID(_currentMenu);

                if (typeName _newMenu == "STRING") then {
                    _newId = _newMenu;
                    _newMenu = HASH_GET(GVAR(Menus), _newMenu);
                };

                if (!isNil "_oldId" && {!isNil "_newId"}) then {
                    if (MENU_ID(_currentMenu) != MENU_ID(_newMenu)) then {
                        [_newMenu, _currentMenu] call FUNC(changeMenu);
                    } else {
                        [_currentMenu, _currentMenu] call FUNC(renderMenu);
                    };
                } else {
                    if (!isNil "_newId" && {isNil "_oldId"} || {isNil "_newId" && {!isNil "_oldId"}}) then {
                        [_newMenu] call FUNC(changeMenu);
                    } else {
                        [_currentMenu, _currentMenu] call FUNC(renderMenu);
                    };
                };
            };
        };
    };
};


#ifdef ENABLE_PERFORMANCE_COUNTERS
    END_COUNTER(buttonPress);
#endif

true
