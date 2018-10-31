#include "script_component.hpp"
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

if !(_this params [["_curveScale", 0, [0]]]) exitWith {
    ERROR("Function called with invalid argument.");
    false;
};

if (_curveScale >= 0) then {
    ACRE_VOICE_CURVE_SCALE = _curveScale;
    publicVariable "ACRE_VOICE_CURVE_SCALE";
} else {
    WARNING("Voice curve scale must be a number greater or equal to 0!");
};
