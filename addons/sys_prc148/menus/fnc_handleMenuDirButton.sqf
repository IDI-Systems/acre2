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
 * [ARGUMENTS] call acre_sys_prc148_fnc_handleMenuDirButton
 *
 * Public: No
 */

params ["_dir", "_params"];

//acre_player sideChat format["p: %1", _params];
if (GET_STATE("editEntry")) then {
    private _alt = _params select 7;
    private _menuEntry = (GVAR(currentMenu) select (GVAR(entryMap) select 0)) select (GVAR(entryMap) select 1);
    _menuEntry params ["", "_value", "_row", "_range", "_type"];

    if (_alt && _type != MENU_TYPE_LIST) then {
        if (_type == MENU_TYPE_TEXT) then {
            private _length = (_range select 1) - (_range select 0);
            private _newIndex = ENTRY_INDEX + _dir;
            if (_newIndex < 0) then {
                _newIndex = _length;
            };
            if (_newIndex > _length) then {
                _newIndex = 0;
            };
            SET_ENTRY_INDEX(_newIndex);
        } else {
            _value = GET_STATE("currentEditEntry");
            //acre_player sideChat format["v: '%1'", _value];
            private _length = (count (toArray _value))-1;

            private _newIndex = ENTRY_INDEX + _dir;
            if (_newIndex < 0) then {
                _newIndex = _length;
            };
            if (_newIndex > _length) then {
                _newIndex = 0;
            };
            SET_ENTRY_INDEX(_newIndex);
        };
    } else {
        //acre_player sideChat "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        switch _type do {
            case MENU_TYPE_LIST: {
                private _list = _menuEntry select 7;
                _value = GET_STATE("currentEditEntry");
                private _index = _list find _value;

                _index = _index + _dir;
                if (_index < 0) then {
                    _index = (count _list) - 1;
                };
                if (_index > (count _list) - 1) then {
                    _index = 0;
                };
                _value = _list select _index;
                SET_STATE("currentEditEntry",_value);
            };
            case MENU_TYPE_TEXT: {
                private _entryIndex = ENTRY_INDEX;
                _value = GET_STATE("currentEditEntry");
                if (isNil "_value") then {
                    _value = "";
                    for "_i" from 1 to (_range select 1) - (_range select 0) do {
                        _value = " " + _value;
                    };
                };
                private _valArray = toArray _value;

                private _currentCharValue = toString [_valArray select _entryIndex];
                private _charIndex = GVAR(alphaNumeric) find _currentCharValue;
                _charIndex = _charIndex + _dir;
                if (_charIndex < 0) then {
                    _charIndex = (count GVAR(alphaNumeric)) - 1;
                };
                if (_charIndex >= (count GVAR(alphaNumeric))) then {
                    _charIndex = 0;
                };
                _valArray set[_entryIndex, (toArray (GVAR(alphaNumeric) select _charIndex)) select 0];
                //acre_player sideChat format["_valArray after: %1", _valArray];
                _value = toString _valArray;

                SET_STATE("currentEditEntry",_value);
            };
            case MENU_TYPE_NUM: {

                private _entryIndex = ENTRY_INDEX;
                _value = GET_STATE("currentEditEntry");
                //acre_player sideChat format["ei: %1", _entryIndex];
                private _valArray = toArray _value;
                private _currentCharValue = toString [_valArray select _entryIndex];
                private _charIndex = GVAR(numeric) find _currentCharValue;
                _charIndex = _charIndex + _dir;
                if (_charIndex < 0) then {
                    _charIndex = (count GVAR(numeric)) - 1;
                };
                if (_charIndex >= (count GVAR(numeric))) then {
                    _charIndex = 0;
                };
                _valArray set [_entryIndex, (toArray (GVAR(numeric) select _charIndex)) select 0];
                //acre_player sideChat format["_valArray after: %1", _valArray];
                _value = toString _valArray;

                SET_STATE("currentEditEntry",_value);
            };
        };
    };
} else {
    [GVAR(currentMenu), (_dir*-1)] call FUNC(menuMoveCursor);
};
