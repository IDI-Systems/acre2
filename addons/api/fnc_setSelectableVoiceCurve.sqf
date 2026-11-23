#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the selectable voice curve scale. This can be used to make the local player's voice travel further or lesser. Typically 0.1 is used for whispering and 1.3 is used for shouting.
 *
 * Arguments:
 * 0: Voice Curve Level <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0.7] call acre_api_fnc_setSelectableVoiceCurve
 *
 * Public: Yes
 */

params [["_curveScale", 0, [0]]];

if (_curveScale >= 0) then {
    // Sent to listeners with our transmissions (see acre_sys_core_fnc_voiceStatePFH).
    EGVAR(sys_core,curveScale) = _curveScale;
    GVAR(selectableCurveScale) = _curveScale;
} else {
    WARNING("Voice curve scale must be a number greater or equal to 0!");
};
