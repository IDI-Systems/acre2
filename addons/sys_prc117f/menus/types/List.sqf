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

DFUNC(onButtonPress_List) = {
//    TRACE_1("onButtonPress_List",_this);
    params ["_menu", "_event"];

    private _currentSelection = GET_STATE_DEF("menuSelection",0);
    private _selectedMenu = MENU_SUBMENUS_ITEM(_menu,_currentSelection);
    TRACE_3("",_currentSelection,_selectedMenu,_menu);
    switch (_event select 0) do {
        case 'ENT': {
            [_selectedMenu, _menu] call FUNC(changeMenu);
        };
        case 'CLR': {
            // Back out of the menu back to the root menu of this menu...confusing right?
            private _homeDisplay = GET_STATE_DEF("currentHome",GVAR(VULOSHOME));
            [_homeDisplay] call FUNC(changeMenu);
        };
        case 'LEFT': {
            TRACE_1("Enter LEFT",_currentSelection);
            if (_currentSelection > 0 ) then {
                _currentSelection = _currentSelection - 1;
            };
        };
        case 'RIGHT': {
            TRACE_1("Enter RIGHT",_currentSelection);
            if (_currentSelection+1 < (count MENU_SUBMENUS(_menu) )) then {
                _currentSelection = _currentSelection + 1;
            };
        };
        default {
            //diag_log text format["!!! UNHANDLED KEY FOR LIST"];
        };
    };

    SET_STATE("menuSelection",_currentSelection);

    false
};

DFUNC(renderMenu_List) = {
    TRACE_1("renderMenu_List",_this);
    private ["_currentPage", "_currentSelectionIndex"];
    params ["_menu"]; // the menu to render is passed

    if ((count MENU_SUBMENUS(_menu)) > 0) then {
        [11, MENU_PATHNAME(_menu)] call FUNC(renderText);

        // Set our page based on the current selection index
        private _currentSelection = GET_STATE_DEF("menuSelection",0);
        private _pageCount = floor ((count MENU_SUBMENUS(_menu)) / MAX_MENU_ITEMS_PER_PAGE)+1;

        if (_currentSelection >= MAX_MENU_ITEMS_PER_PAGE) then {
            _currentPage = (_currentSelection+MAX_MENU_ITEMS_PER_PAGE) / MAX_MENU_ITEMS_PER_PAGE;
            _currentPage = floor _currentPage;
            _currentSelectionIndex = _currentSelection % MAX_MENU_ITEMS_PER_PAGE;
        } else {
            _currentPage = 1;
            _currentSelectionIndex = _currentSelection;
        };
        TRACE_5("Page index",MAX_MENU_ITEMS_PER_PAGE,_pageCount,_currentSelection,_currentPage,_currentSelectionIndex);

        // Render the current menus
        private _firstDisplayRow = "";
        private _secondDisplayRow = "";

        for "_i" from 1 to MAX_MENU_ITEMS_PER_PAGE do {

            private _itemIndex = (((_currentPage-1) * MAX_MENU_ITEMS_PER_PAGE) + (_i-1));
            if (_itemIndex >= (count MENU_SUBMENUS(_menu))) exitWith {};

            private _item = MENU_SUBMENUS_ITEM(_menu,_itemIndex);
            private _itemDisplayName = MENU_DISPLAYNAME(_item);
            TRACE_5("Item rendering",_itemIndex,_itemDisplayName,_item,_currentPage,_i);

            if (_i <= MAX_MENU_ITEMS_PER_PAGE/2 ) then {
                _firstDisplayRow = _firstDisplayRow + _itemDisplayName + "  ";
            } else {
                _secondDisplayRow = _secondDisplayRow + _itemDisplayName + "  ";
            };
        };
        TRACE_2("Rendering rows",_firstDisplayRow,_secondDisplayRow);
        [ROW_LARGE_2, _firstDisplayRow, ALIGN_CENTER] call FUNC(renderText);
        [ROW_LARGE_3, _secondDisplayRow, ALIGN_CENTER] call FUNC(renderText);

        [ROW_SMALL_5, "USE < > TO SELECT ITEM", ALIGN_CENTER] call FUNC(renderText);
        [_menu, _currentSelection, _currentSelectionIndex, [_firstDisplayRow, _secondDisplayRow]] call FUNC(drawCursor_List);
    } else {
        // TODO: change menu to the "no menu items" display!!!
    };
};

DFUNC(drawCursor_List) = {
        TRACE_1("drawCursor_List",_this);
    private ["_row"];
    params ["_menu", "_currentSelection", "_currentSelectionIndex", "_data"];

    private _currentItemDisplayName = MENU_DISPLAYNAME(MENU_SUBMENUS_ITEM(_menu,_currentSelection));

    // optional 3rd argument of range
    private _len = (count (toArray _currentItemDisplayName)) ;
    TRACE_2("CURSORING",_len,_currentItemDisplayName);

    private _rowText = "";
    if (_currentSelectionIndex < MAX_MENU_ITEMS_PER_PAGE/2 ) then {
        _row = ROW_LARGE_2;
        _rowText = _data select 0;
    } else {
        _row = ROW_LARGE_3;
        _rowText = _data select 1;
    };

    TRACE_2("Searching for row text",_row,_rowText);

    private _result = [_rowText, _currentItemDisplayName] call CBA_fnc_find;
    if (_result != -1) then {
        TRACE_1("Dumping cursor at",_result);
        [_row, [_result,_len], true, ALIGN_CENTER] call FUNC(drawCursor);
    };
    // We need to walk and figure out how to determine if its row 1 or 2 for the select, and also
    // the spacing its at which is centered, len + 2 + len + 2 depending on 1/2/3
};
