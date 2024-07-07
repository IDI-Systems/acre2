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
 * [ARGUMENTS] call acre_sys_prc148_fnc_handleMenuButtonEnter
 *
 * Public: No
 */

private _menuEntry = (GVAR(currentMenu) select (GVAR(entryMap) select 0)) select (GVAR(entryMap) select 1);
if (!GET_STATE("editEntry")) then {
    SET_STATE("editEntry",true);
    _menuEntry = (GVAR(currentMenu) select (GVAR(entryMap) select 0)) select (GVAR(entryMap) select 1);
    _menuEntry params ["", "_value", "_row", "_range", "_type"];

    switch _type do {
        case MENU_TYPE_TEXT: {
            SET_ENTRY_INDEX(0);
            SET_STATE("currentEditEntry",_value);
        };
        case MENU_TYPE_NUM: {
            private _format = _menuEntry select 6;

            private _formatLength = 0;
            private _formatArray = toArray _format;
            {
                if (toString [_x] == "#") then {
                    _formatLength = _formatLength + 1;
                };
            } forEach _formatArray;
            private _valLength = (count (toArray _value));
            //acre_player sideChat format["v: %1 f: %2", _valLength, _formatLength];
            if (_valLength < _formatLength) then {
                for "_i" from 1 to _formatLength - _valLength do {
                    //acre_player sideChat "AA!";
                    _value = " " + _value;
                };
            };
            //acre_player sideChat format["VAL: '%1'", _value];
            private _length = (count (toArray _value)) - 1;
            SET_ENTRY_INDEX(_length);
            SET_STATE("currentEditEntry",_value);
        };
        case MENU_TYPE_LIST: {
            SET_STATE("currentEditEntry",_value);
        };
        case MENU_TYPE_MENU: {
            private _call = _menuEntry select 5;
            private _newValue = GET_STATE("currentEditEntry");
            [_newValue, _menuEntry] call _call;
            SET_STATE("editEntry",false);
            SET_STATE("currentEditEntry","")
        };
    };
} else {
    //acre_player sideChat "BOOP SHABOOP";
    private _call = _menuEntry select 5;
    private _newValue = GET_STATE("currentEditEntry");
    [_newValue, _menuEntry] call _call;
    SET_STATE("editEntry",false);
    SET_STATE("currentEditEntry","")

};
