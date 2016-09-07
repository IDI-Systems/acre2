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
 * Public: Yes
 */
#include "script_component.hpp"

params ["_curveScale"];

if(IS_NUMBER(_curveScale)) then {
    if(_curveScale >= 0) then {
        ACRE_VOICE_CURVE_SCALE = _curveScale;
        publicVariable "ACRE_VOICE_CURVE_SCALE";
    } else {
        diag_log text format["ACRE: VOICE CURVE SCALE MUST BE A NUMBER GREATER OR EQUAL TO 0"];
    };
} else {
    diag_log text format["ACRE: VOICE CURVE SCALE MUST BE A NUMBER GREATER OR EQUAL TO 0"];
};
