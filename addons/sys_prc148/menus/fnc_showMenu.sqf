/*
 * Author: AUTHOR
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

private ["_pageIndex", "_menuIndex", "_entryIndex", "_selectedEntry", "_currentPage", "_entry", "_x", "_isEdit", "_forEachIndex", "_format", "_formatArray", "_offset", "_valLength", "_formatLength", "_searchDepth", "_i", "_formatChar", "_highlight", "_list", "_labels"];
params["_display", "_menu"];

_pageIndex = PAGE_INDEX;
_menuIndex = MENU_INDEX;
_entryIndex = ENTRY_INDEX;
_selectedEntry = SELECTED_ENTRY;
//acre_player sideChat format["_pageIndex: %1, _menuIndex: %2, _entryIndex: %3, _selectedEntry: %4",
                            // _pageIndex,
                            // _menuIndex,
                            // _entryIndex,
                            // _selectedEntry
                        // ];
_currentPage = _menu select _pageIndex;
/*
[
    [
        "TEXT",             //0 Value
        BIG_LINE_1,            //1 Row
        [1,10],             //2 Range
        MENU_TYPE_LIST        //3 Type
*/
{
    _entry = _x;
    _entry params ["","_value","_row","_range","_type"];

    _isEdit = false;
    if(_forEachIndex == _menuIndex) then {
        GVAR(entryMap) = [_pageIndex, _menuIndex];
        if(GET_STATE(editEntry)) then {
            _isEdit = true;
            _value = GET_STATE(currentEditEntry);
        };
        [_display, _row, _range] call FUNC(setCursor);
    };



    switch _type do {
        case MENU_TYPE_TEXT: {
            [_display, _row, _range, _value] call FUNC(setText);
            if(_isEdit) then {
                [_display, _row, [(_range select 0)+_entryIndex, (_range select 0)+_entryIndex], true] call FUNC(highlightText);
            };
        };
        case MENU_TYPE_MENU: {
            [_display, _row, _range, _value] call FUNC(setText);
        };
        case MENU_TYPE_NUM: {
            _format = _entry select 6;
            [_display, _row, _range, _value, _format] call FUNC(setText);

            if(_isEdit) then {
                _formatArray = toArray _format;
                _offset = 0;
                _valLength = (count (toArray _value))-1;

                _formatLength = (count _formatArray)-1;

                _searchDepth = (_formatLength - (_valLength-_entryIndex));
                for "_i" from _formatLength to _searchDepth step -1 do {
                    _formatChar = toString [(_formatArray select _i)];
                    if(_formatChar != "#") then {
                        _offset = _offset + 1;
                        _searchDepth = _searchDepth + 1;
                    };
                };

                _highlight = (_range select 1)-(_valLength-_entryIndex)-_offset;

                [_display, _row, [_highlight, _highlight], true] call FUNC(highlightText);
            };
        };
        case MENU_TYPE_LIST: {
            _list = _entry select 7;
            _labels = _entry select 6;
            //acre_player sideChat format["value: %1", _labels];
            _index = _list find _value;
            if(_index == -1) then {
                _index = 0;
            };
            [_display, _row, _range, _labels select _index] call FUNC(setText);
            if(_isEdit) then {
                [_display, _row, _range, true] call FUNC(highlightText);
            };
        };
    };

} forEach _currentPage;
if(_pageIndex > 0) then {
    [_display, SMALL_LINE_1, [25,25], toString [8593]] call FUNC(setText);
};
if((count _menu) > 0 && _pageIndex != (count _menu)-1) then {
    [_display, SMALL_LINE_5, [25,25], toString [8595]] call FUNC(setText);
};
