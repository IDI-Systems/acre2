
#include "script_component.hpp"
TRACE_1("createMenu", _this);
private["_menu", "_x", "_subMenuList", "_menuId"];
params["_menu"];

/*if(count _this > 1) then {
	_nested = true;
	_parentMenu = _this select 1;
} else {
	_nested = false;
};*/
// Add a menu
if(!isNil "_menu") then {
    ADD_MENU(_menu);

    // Loop through the menu and add its children if it has ID's
    _subMenuList = MENU_SUBMENUS(_menu);
    if( !isNil "_subMenuList" ) then {		// If there are submenus, loop
        {
            private["_subMenu_id"];
            _subMenu_id = MENU_ID(_x);
            if(! isNil "_subMenu_id" ) then {
                if(MENU_TYPE(_x) == MENUTYPE_DISPLAY || 
                MENU_TYPE(_x) == MENUTYPE_LIST ||
                MENU_TYPE(_x) == MENUTYPE_ACTIONSERIES) then {
                    [_x, _menu] call FUNC(createMenu);
                };
            };
            // Set the last item of every sub-menu item to the ID of the parent
            // This is the parent ref
            MENU_SET_PARENT_ID(_x,_menu);
        } forEach _subMenuList;
    };
};