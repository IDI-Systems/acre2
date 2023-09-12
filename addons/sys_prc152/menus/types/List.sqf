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
//    TRACE_1("onButtonPress_List", _this);
    params ["_menu", "_event"];

    private _currentSelection = GET_STATE_DEF("menuSelection", 0);
    private _selectedMenu = MENU_SUBMENUS_ITEM(_menu, _currentSelection);
    TRACE_3("", _currentSelection, _selectedMenu, _menu);
    switch (_event select 0) do {
        case 'ENT': {
            [_selectedMenu, _menu] call FUNC(changeMenu);
        };
        case 'CLR': {
            // Back out of the menu back to the root menu of this menu...confusing right?
            private _homeDisplay = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
            [_homeDisplay] call FUNC(changeMenu);
        };
        case '6': {
            TRACE_1("Enter 6", _currentSelection);
            if (_currentSelection > 0 ) then {
                _currentSelection = _currentSelection - 1;
            };
        };
        case '9': {
            TRACE_1("Enter 9", _currentSelection);
            if (_currentSelection+1 < (count MENU_SUBMENUS(_menu) )) then {
                _currentSelection = _currentSelection + 1;
            };
        };
        default {
            //diag_log text format["!!! UNHANDLED KEY FOR LIST"];
        };
    };

    SET_STATE("menuSelection", _currentSelection);

    false
};

DFUNC(renderMenu_List) = {
    TRACE_1("renderMenu_List", _this);
    private ["_currentPage", "_currentSelectionIndex"];
    params ["_menu"]; // the menu to render is passed

    if ((count MENU_SUBMENUS(_menu)) > 0) then {
        [11, MENU_PATHNAME(_menu)] call FUNC(renderText);

        if ((count MENU_SUBMENUS(_menu)) > 3) then {
            [ICON_SCROLLBAR, true] call FUNC(toggleIcon);
        };
        // Set our page based on the current selection index
        private _currentSelection = GET_STATE_DEF("menuSelection", 0);
        private _pageCount = floor ((count MENU_SUBMENUS(_menu)) / MAX_MENU_ITEMS_PER_PAGE)+1;

        if (_currentSelection >= MAX_MENU_ITEMS_PER_PAGE) then {
            _currentPage = (_currentSelection+MAX_MENU_ITEMS_PER_PAGE) / MAX_MENU_ITEMS_PER_PAGE;
            _currentPage = floor _currentPage;
            _currentSelectionIndex = _currentSelection % MAX_MENU_ITEMS_PER_PAGE;
        } else {
            _currentPage = 1;
            _currentSelectionIndex = _currentSelection;
        };
        TRACE_4("Page index", _pageCount, _currentSelection, _currentPage, _currentSelectionIndex);

        // Render the current menus
        for "_i" from 1 to MAX_MENU_ITEMS_PER_PAGE do {

            private _itemIndex = (((_currentPage-1) * MAX_MENU_ITEMS_PER_PAGE) + (_i-1));
            if (_itemIndex >= (count MENU_SUBMENUS(_menu))) exitWith {};

            private _item = MENU_SUBMENUS_ITEM(_menu, _itemIndex);
            private _itemDisplayName = MENU_DISPLAYNAME(_item);
            TRACE_4("Item rendering", _itemDisplayName, _item, _currentPage, _i);

            [ROW_LARGE_1+(_i), _itemDisplayName] call FUNC(renderText);
        };

        [_menu, _currentSelection, _currentSelectionIndex] call FUNC(drawCursor_List);
    } else {
        // TODO: change menu to the "no menu items" display!!!
    };
};

DFUNC(drawCursor_List) = {
        TRACE_1("drawCursor_List", _this);
    private ["_len"];
    params ["_menu","_currentSelection","_currentSelectionIndex"];

    private _currentItemDisplayName = MENU_DISPLAYNAME( MENU_SUBMENUS_ITEM(_menu, _currentSelection) );

    // optional 3rd argument of range
    if (count _this > 3) then {
        _len = _this select 3;
    } else {
        _len = (count (toArray _currentItemDisplayName)) - 1;
    };
    TRACE_2("CURSORING", _len, _currentItemDisplayName);

    [22+_currentSelectionIndex, [0,_len]] call FUNC(drawCursor);
};
