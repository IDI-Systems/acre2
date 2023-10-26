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

DFUNC(onButtonPress_Static) = {
    TRACE_1("onButtonPress_Static", _this);


    false
};

DFUNC(renderMenu_Static) = {
    TRACE_1("renderMenu_Static", _this);
    params ["_menu"]; // the menu to render is passed
    private _displaySet = MENU_SUBMENUS(_menu);

    private _valueHash = HASH_CREATE;

    [] call FUNC(clearDisplay);

    // Call entry
    [_menu] call FUNC(callRenderFunctor);

    if (!isNil "_displaySet" && _displaySet isEqualType [] && (count _displaySet) > 0) then {
        {
            [(_x select 0),
             (_x select 2),
             (_x select 1),
             _valueHash
              ] call FUNC(renderText);
        } forEach MENU_SUBMENUS(_menu);
    };


};
