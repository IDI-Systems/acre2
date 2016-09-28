/*
 * Author: ACRE2Team
 * Sets the selectable voice curve scale. This can be used to make the local player's voice travel further or lesser. Typically 0.1 is used for whispering and 1.3 is used for shouting.
 *
 * Arguments:
 * 0: selectable voice curve <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1.0] call acre_api_fnc_setSelectableVoiceCurve;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_curveScale"];

if(IS_NUMBER(_curveScale)) then {
    if(_curveScale >= 0) then {
        ["setSelectableVoiceCurve", format["%1,", _curveScale]] call EFUNC(sys_rpc,callRemoteProcedure);
        GVAR(selectableCurveScale) = _curveScale;
    } else {
        diag_log text format["ACRE: SELECTABLE VOICE CURVE SCALE MUST BE A NUMBER GREATER OR EQUAL TO 0"];
    };
} else {
    diag_log text format["ACRE: SELECTABLE VOICE CURVE SCALE MUST BE A NUMBER GREATER OR EQUAL TO 0"];
};
