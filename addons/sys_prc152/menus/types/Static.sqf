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
    TRACE_1("onButtonPress_Static",_this);

    false
};

DFUNC(renderMenu_Static) = {
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(renderMenu_Static);
    #endif

    TRACE_1("renderMenu_Static",_this);
    params ["_menu"]; // the menu to render is passed

    private _displaySet = MENU_SUBMENUS(_menu);

    private _valueHash = HASH_CREATE;

    [] call FUNC(clearDisplay);

    // Call entry
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(renderMenu_Static_Functor);
    #endif

    [_menu] call FUNC(callRenderFunctor);

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(renderMenu_Static_Functor);
        BEGIN_COUNTER(renderMenu_Static_setText);
    #endif

    if (!isNil "_displaySet" && {_displaySet isEqualType []} && {_displaySet isNotEqualTo []}) then {
        {
            [
                (_x select 0),
                (_x select 2),
                (_x select 1),
                _valueHash
            ] call FUNC(renderText);
        } forEach MENU_SUBMENUS(_menu);
    };

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(renderMenu_Static_setText);
        END_COUNTER(renderMenu_Static);
    #endif
};
