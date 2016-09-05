//fnc_setCurveModelScale.sqf
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