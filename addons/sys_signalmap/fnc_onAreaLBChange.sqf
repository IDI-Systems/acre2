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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_onAreaLBChange;
 *
 * Public: No
 */
 
with uiNamespace do {
    if ((count GVAR(rxAreas)) > 0) then {
        {
            (_x select 1) setMarkerColorLocal "ColorYellow";
            (_x select 1) setMarkerBrushLocal "DiagGrid";
            (_x select 1) setMarkerAlphaLocal 0.5;

        } forEach GVAR(rxAreas);
        ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerColorLocal "ColorRed";
        ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerBrushLocal "Solid";
        ((GVAR(rxAreas) select (_this select 1)) select 1) setMarkerAlphaLocal 1;


    };
};
