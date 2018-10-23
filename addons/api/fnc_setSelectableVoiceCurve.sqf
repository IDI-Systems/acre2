#include "script_component.hpp"
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

params [
    ["_curveScale", 0, [0]]
];


if (IS_NUMBER(_curveScale)) then {
    if (_curveScale >= 0) then {
        ["setSelectableVoiceCurve", format["%1,", _curveScale]] call EFUNC(sys_rpc,callRemoteProcedure);
        GVAR(selectableCurveScale) = _curveScale;
    } else {
        WARNING("Voice curve scale must be a number greater or equal to 0!");
    };
} else {
    WARNING("Voice curve scale must be a number greater or equal to 0!");
};
