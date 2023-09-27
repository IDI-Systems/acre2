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
 * [ARGUMENTS] call acre_sys_prc148_fnc_menuMoveCursor
 *
 * Public: No
 */

params ["_menu", "_direction"];

private _pageIndex = PAGE_INDEX;
private _menuIndex = MENU_INDEX;
private _entryIndex = ENTRY_INDEX;
private _selectedEntry = SELECTED_ENTRY;

if (_menuIndex + _direction > (count (_menu select _pageIndex))-1 || {_menuIndex + _direction < 0}) then {
    if (_pageIndex + _direction <= ((count _menu)-1) && {_pageIndex + _direction >= 0}) then {
        if (_direction == -1) then {
            SET_MENU_INDEX((count (_menu select _pageIndex-1)-1));
        } else {
            SET_MENU_INDEX(0);
        };
        SET_PAGE_INDEX(_pageIndex + _direction);
    };
} else {
    SET_MENU_INDEX(_menuIndex + _direction);
};
