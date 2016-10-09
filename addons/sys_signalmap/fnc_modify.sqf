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

#include "script_component.hpp"

[] spawn {
    sleep 0.1;
    [] call FUNC(clearOverlayMessage);
};
with uiNamespace do {
    {
        (_x select 1) setMarkerAlphaLocal 1;
    } forEach GVAR(rxAreas);
};
