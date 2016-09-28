/*
 * Author: ACRE2Team
 * Sets the curve model for all clients. This model affects the dropoff for direct speech.
 * ACRE_CURVE_MODEL_ORIGINAL > The volume range is static and based off a custom curve.
 * ACRE_CURVE_MODEL_SELECTABLE_A > This method allows you to use the acre_api_fnc_setSelectableVoiceCurve to change how far the voice curve goes. The curve that the it modifies in mode A is the default X3DAudio curve based off the inverse square law.
 * ACRE_CURVE_MODEL_SELECTABLE_B > Same as above but it modifies the distance of the custom curve available when using the ACRE_CURVE_MODEL_ORIGINAL mode.
 *
 * Arguments:
 * 0: "ACRE_CURVE_MODEL_ORIGINAL", "ACRE_CURVE_MODEL_SELECTABLE_A" or "ACRE_CURVE_MODEL_SELECTABLE_B" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_CURVE_MODEL_ORIGINAL"] call acre_api_fnc_setCurveModel;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_modelType"];

switch _modelType do {
    case "ACRE_CURVE_MODEL_ORIGINAL": {
        ACRE_VOICE_CURVE_MODEL = ACRE_CURVE_MODEL_ORIGINAL;
    };
    // case "ACRE_CURVE_MODEL_AMPLITUDE": {
        // ACRE_VOICE_CURVE_MODEL = ACRE_CURVE_MODEL_AMPLITUDE;
    // };
    case "ACRE_CURVE_MODEL_SELECTABLE_A": {
        ACRE_VOICE_CURVE_MODEL = ACRE_CURVE_MODEL_SELECTABLE_A;
    };
    case "ACRE_CURVE_MODEL_SELECTABLE_B": {
        ACRE_VOICE_CURVE_MODEL = ACRE_CURVE_MODEL_SELECTABLE_B;
    };
    default {
        diag_log text format["ACRE: VOICE CURVE MODEL ""%1"" DOES NOT EXIST!", _modelType];
    };
};

publicVariable "ACRE_VOICE_CURVE_MODEL";
