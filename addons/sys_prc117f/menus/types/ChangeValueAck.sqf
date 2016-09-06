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

DFUNC(onButtonPress_ChangeValueAck) = {
    TRACE_1("onButtonPress_ChangeValueAck", _this);


    false
};

DFUNC(renderMenu_ChangeValueAck) = {
    TRACE_1("renderMenu_ChangeValueAck", _this);
    private["_displaySet", "_valueHash"];
    params["_menu"]; // the menu to render is passed
    _displaySet = MENU_SUBMENUS(_menu);

    _valueHash = HASH_CREATE;

    [] call FUNC(clearDisplay);

    // Call entry
    [_menu] call FUNC(callRenderFunctor);

    if(!isNil "_displaySet" && _displaySet isEqualType [] && (count _displaySet) > 0) then {
        {
            [(_x select 0),
             (_x select 2),
             (_x select 1),
             _valueHash
              ] call FUNC(renderText);
        } forEach MENU_SUBMENUS(_menu);
    };


};
