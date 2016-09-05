//fnc_setCurveModel.sqf
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