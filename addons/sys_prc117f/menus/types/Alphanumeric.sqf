#include "..\..\script_component.hpp"
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

GVAR(NumpadMap) = [
    [" ", "0"],
    ["A","B","C","1"],
    ["D","E","F","2"],
    ["G","H","I","3"],
    ["J","K","L","4"],
    ["M","N","O","5"],
    ["P","Q","R","6"],
    ["S","T","U","7"],
    ["V","W","X","8"],
    ["Y","Z","?","9"]
];

DFUNC(doAlphanumericButton) = {
    params ["_menu", "_event"];

    private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaCursor", 0);

    private _editButtonPress = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaCursorPress", 0);

    private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 0);
    private _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuString", "");

    private _number = parseNumber (_event select 0);
    private _key = _event select 0;

    private _lastButton = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaLastButton", _key);
    if (_lastButton != _key) then {
        _editButtonPress = 0;
        [_menu, ['RIGHT']] call FUNC(onButtonPress_Alphanumeric);
    };

    TRACE_1("", _number);
    if (_number > -1 && _number < 10) then {

        private _arr = toArray _value;
        private _character = _arr select _editIndex;

        _character = ( toArray ((GVAR(NumpadMap) select _number) select _editButtonPress) select 0);
        TRACE_4("Values", _character, _number, _editButtonPress, _arr);

        _arr set[_editIndex, _character];
        _value = toString _arr;

        TRACE_2("Values 2", _editIndex, _character);
        TRACE_1("New value", _value);

        // Increment the next character to use
        if (_editButtonPress + 1 >= (count (GVAR(NumpadMap) select _number))) then {
            _editButtonPress = 0;
        } else {
            _editButtonPress = _editButtonPress + 1;
        };

        SCRATCH_SET(GVAR(currentRadioId), "menuAlphaLastButton", _key);
        SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursorPress", _editButtonPress);
        SCRATCH_SET(GVAR(currentRadioId), "menuString", _value);

        // Re-render it
        [_menu] call FUNC(renderMenu_Alphanumeric);
    };

    true
};

DFUNC(onButtonPress_Alphanumeric) = {
    params ["_menu", "_event"];

    private _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuString", "");

    TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!", (_event select 0));
    switch (_event select 0) do {
        case '1': { _this call FUNC(doAlphanumericButton); };
        case '2': { _this call FUNC(doAlphanumericButton); };
        case '3': { _this call FUNC(doAlphanumericButton); };
        case '4': { _this call FUNC(doAlphanumericButton); };
        case '5': { _this call FUNC(doAlphanumericButton); };
        case '6': { _this call FUNC(doAlphanumericButton); };
        case '7': { _this call FUNC(doAlphanumericButton); };
        case '8': { _this call FUNC(doAlphanumericButton); };
        case '9': { _this call FUNC(doAlphanumericButton); };
        case '0': { _this call FUNC(doAlphanumericButton); };
        case 'LEFT': {
            private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 0);
            private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaCursor", 0);
            if (_editIndex > 0) then {
                _editIndex = _editIndex -1;
            } else {
                _editIndex = _editDigits -1;
            };
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursor", _editIndex);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursorPress", 0);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaLastButton", nil);
            [_menu] call FUNC(renderMenu_Alphanumeric);
        };
        case 'RIGHT': {
            private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 0);
            private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaCursor", 0);
            if (_editIndex+1 < _editDigits) then {
                _editIndex = _editIndex + 1;
            } else {
                _editIndex = 0;
            };
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursor", _editIndex);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursorPress", 0);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaLastButton", nil);
            [_menu] call FUNC(renderMenu_Alphanumeric);
        };
        case 'ENT': {
            // swap to the parent
            TRACE_1("onButtonPress_Alphanumeric: ENT hit", _value);

            private _saveName = MENU_SELECTION_VARIABLE(_menu);
            SET_STATE(_saveName, _value);

            SCRATCH_SET(GVAR(currentRadioId), "menuString", nil);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaCursorPress", 0);
            SCRATCH_SET(GVAR(currentRadioId), "menuAlphaLastButton", nil);

            TRACE_2("Saved", _saveName, (GET_STATE(_saveName)));

            // Our parent?
            TRACE_1("Parent", MENU_PARENT_ID(_menu));
            [MENU_PARENT_ID(_menu)] call FUNC(changeMenu);
        };
        case 'CLR': {
            TRACE_1("onButtonPress_Alphanumeric: CLR hit","");
            private _parentMenu = HASH_GET(GVAR(Menus), MENU_PARENT_ID(_menu));
            private _useParent = true;

            //If Parent action series -> Go to its parent.
            if (!isNil "_parentMenu" && {MENU_TYPE(_parentMenu) == MENUTYPE_ACTIONSERIES}) then {
                private _pid = MENU_PARENT_ID(_parentMenu);
                if (_pid isEqualType "") then {
                    _useParent = false;
                    SET_STATE("menuAction", 0);
                    [_pid] call FUNC(changeMenu);
                };
            };

            if (_useParent) then {
                [MENU_PARENT_ID(_menu)] call FUNC(changeMenu);
            };
        };
        default {
            //diag_log text format["!!! UNHANDLED KEY FOR SELECTION"];
        };
    };
};

DFUNC(renderMenu_Alphanumeric) = {
    params ["_menu"]; // the menu to render is passed
    private _displaySet = MENU_SUBMENUS(_menu);

    private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuAlphaCursor", 0);
    private _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuString", "");

    private _valueHash = HASH_CREATE;
    HASH_SET(_valueHash, "1", _value);

    [] call FUNC(clearDisplay);
    if (!isNil "_displaySet" && _displaySet isEqualType [] && (count _displaySet) > 0) then {
        {
            // Data selection row
            [(_x select 0),
             (_x select 2),
             (_x select 1),
              _valueHash] call FUNC(renderText);
        } forEach MENU_SUBMENUS(_menu);
    };

    [ROW_SMALL_1, MENU_PATHNAME(_menu)] call FUNC(renderText);        // Header line
    private _editLocation = (MENU_SELECTION_DISPLAYSET(_menu) select 1);    // cursor location from the config

    [(_editLocation select 0),
    [(_editLocation select 1)+_editIndex,
    1], true, ALIGN_CENTER] call FUNC(drawCursor);
};
