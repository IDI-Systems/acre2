//fnc_menuMoveCursor.sqf
#include "script_component.hpp"

private ["_pageIndex", "_menuIndex", "_entryIndex", "_selectedEntry"];
params["_menu", "_direction"];

_pageIndex = PAGE_INDEX;
_menuIndex = MENU_INDEX;
_entryIndex = ENTRY_INDEX;
_selectedEntry = SELECTED_ENTRY;

if(_menuIndex + _direction > (count (_menu select _pageIndex))-1 || _menuIndex + _direction < 0) then {
    if(_pageIndex + _direction <= ((count _menu)-1) && _pageIndex + _direction >= 0) then {
        if(_direction == -1) then {
            SET_MENU_INDEX((count (_menu select _pageIndex-1)-1));
        } else {
            SET_MENU_INDEX(0);
        };
        SET_PAGE_INDEX(_pageIndex + _direction);
    };
} else {
    SET_MENU_INDEX(_menuIndex + _direction);
};
