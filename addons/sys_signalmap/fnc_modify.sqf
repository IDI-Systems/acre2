#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_modify;
 *
 * Public: No
 */

[] spawn {
    sleep 0.1;
    [] call FUNC(clearOverlayMessage);
};

with uiNamespace do {
    {
        (_x select 1) setMarkerAlphaLocal 1;
    } forEach GVAR(rxAreas);
};
