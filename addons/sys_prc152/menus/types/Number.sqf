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

GVAR(NumpadMap_Number) = [
    ["0"],
    ["1"],
    ["2"],
    ["3"],
    ["4"],
    ["5"],
    ["6"],
    ["7"],
    ["8"],
    ["9"]
];

DFUNC(doNumberButton) = {
    params ["_menu","_event"];

    private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumberCursor", 0);

    private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 2);
    private _numberValue = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumber", 0.0);
    private _value = [_numberValue, (MENU_SELECTION_DISPLAYSET(_menu) select 2)] call CBA_fnc_formatNumber;

    private _number = parseNumber (_event select 0);
    private _key = _event select 0;

    TRACE_5("", _number, _numberValue, _value, _editDigits, _editIndex);
    if (_number > -1 && _number < 10) then {

        private _arr = toArray _value;
        private _character = _arr select _editIndex;

        _character = ( toArray ((GVAR(NumpadMap_Number) select _number) select 0) select 0);
        TRACE_3("Values", _character, _number, _arr);

        _arr set[_editIndex, _character];
        _value = toString _arr;

        TRACE_2("Values 2", _editIndex, _character);
        TRACE_1("New value", _value);

        if (_editIndex+1 < _editDigits) then {
            _editIndex = _editIndex + 1;
        } else {
            _editIndex = 0;
        };
        if ( ((toArray _value) select _editIndex) == 46) then {
            // recursively push a button again, since we want to skip it.
            TRACE_1("Edit digit incrementing hit a dot, skip it","");
            _editIndex = _editIndex + 1;
        };

        _numberValue = parseNumber _value;
        TRACE_2("Re-parsed back to int", _numberValue, _value);
        SCRATCH_SET(GVAR(currentRadioId), "menuNumber", _numberValue);
        SCRATCH_SET(GVAR(currentRadioId), "menuNumberCursor", _editIndex);

        // Re-render it
        [_menu] call FUNC(renderMenu_Number);
    };
};

DFUNC(onButtonPress_Number) = {
    params ["_menu","_event"];

    private _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumber", 0.0);

    TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!", (_event select 0));
    switch (_event select 0) do {
        case '1': { _this call FUNC(doNumberButton); };
        case '2': { _this call FUNC(doNumberButton); };
        case '3': { _this call FUNC(doNumberButton); };
        case '4': { _this call FUNC(doNumberButton); };
        case '5': { _this call FUNC(doNumberButton); };
        case '6': { _this call FUNC(doNumberButton); };
        case '7': { _this call FUNC(doNumberButton); };
        case '8': { _this call FUNC(doNumberButton); };
        case '9': { _this call FUNC(doNumberButton); };
        case '0': { _this call FUNC(doNumberButton); };
        case 'LEFT': {
            private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 2);
            private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumberCursor", 0);
            if (_editIndex > 0) then {
                _editIndex = _editIndex -1;
            } else {
                _editIndex = _editDigits;
            };

            TRACE_3("Left hit, checking", _value, _editIndex, _editDigits);
            private _strValue = [_value, (MENU_SELECTION_DISPLAYSET(_menu) select 2)] call CBA_fnc_formatNumber;
            if ( ((toArray _strValue) select _editIndex) == 46) then {
                // recursively push a button again, since we want to skip it.
                TRACE_1("Hit a digit, skipping", _editIndex);
                if (_editIndex > 1) then {
                    _editIndex = _editIndex - 1;
                } else {
                    _editIndex = _editDigits;
                };
            };

            SCRATCH_SET(GVAR(currentRadioId), "menuNumberCursor", _editIndex);
            [_menu] call FUNC(renderMenu_Number);
        };
        case 'RIGHT': {
            private _editDigits = (MENU_SELECTION_DISPLAYSET(_menu) select 2);
            private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumberCursor", 0);
            if (_editIndex+1 < _editDigits) then {
                _editIndex = _editIndex + 1;
            } else {
                _editIndex = 0;
            };

            TRACE_3("Right hit, checking", _value, _editIndex, _editDigits);
            private _strValue = [_value, (MENU_SELECTION_DISPLAYSET(_menu) select 2)] call CBA_fnc_formatNumber;
            if ( ((toArray _strValue) select _editIndex) == 46) then {
                // recursively push a button again, since we want to skip it.
                TRACE_1("Hit a digit, skipping", _editIndex);
                if (_editIndex < _editDigits) then {
                    _editIndex = _editIndex + 1;
                } else {
                    _editIndex = 0;
                };
            };

            SCRATCH_SET(GVAR(currentRadioId), "menuNumberCursor", _editIndex);
            [_menu] call FUNC(renderMenu_Number);
        };
        case 'ENT': {
            // swap to the parent
            TRACE_1("onButtonPress_Number: ENT hit", _value);

            private _saveName = MENU_SELECTION_VARIABLE(_menu);
            SET_STATE(_saveName, _value);

            SCRATCH_SET(GVAR(currentRadioId), "menuNumber", nil);
            SCRATCH_SET(GVAR(currentRadioId), "menuNumberCursor", 0);

            TRACE_2("Saved", _saveName, (GET_STATE(_saveName)));

            // Our parent?
            TRACE_1("Parent", MENU_PARENT_ID(_menu));
            [MENU_PARENT_ID(_menu)] call FUNC(changeMenu);
        };
        case 'CLR': {
            TRACE_1("onButtonPress_Number: CLR hit","");
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

DFUNC(renderMenu_Number) = {
    params ["_menu"]; // the menu to render is passed

    private _displaySet = MENU_SUBMENUS(_menu);

    private _editIndex = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumberCursor", 0);
    private _numberValue = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuNumber", 0.0);

    private _value = [_numberValue, (MENU_SELECTION_DISPLAYSET(_menu) select 2)] call CBA_fnc_formatNumber;
    TRACE_2("Formatted number", _numberValue, _value);

    // Check the current digit. If its a dot, we should skip it.
    // Dot as a DEC value of 46
    if ( ((toArray _value) select _editIndex) == 46) then {
        TRACE_1("Digit was a dot, moving forward", _editIndex);
        _editIndex = _editIndex + 1;
    };

    private _valueHash = HASH_CREATE;
    private _replaceValue = format["$ch%1",_numberValue];
    HASH_SET(_valueHash, "ch", _replaceValue);    // This is a custom menu change to allow displaying the channel in the display
    HASH_SET(_valueHash, "1", _value);
    TRACE_1("Pushed value hash", _value);

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
    private _editLocation = (MENU_SELECTION_DISPLAYSET(_menu) select 3);    // cursor location from the config
    TRACE_1("Rendered, pushing cursor", _editLocation);

    [(_editLocation select 0),
    [(_editLocation select 1)+_editIndex,
    1], true, ALIGN_CENTER] call FUNC(drawCursor);
};
