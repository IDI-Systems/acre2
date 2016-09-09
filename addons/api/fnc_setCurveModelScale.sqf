/*
 * Author: ACRE2Team
 * Sets the curve scale for all clients. This can be used as a modifier for all voice curves.
 *
 * Arguments:
 * 0: Curve scale <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1.0] call acre_api_fnc_setCurveModelScale;
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
