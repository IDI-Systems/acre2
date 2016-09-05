//fnc_ITULoss.sqf
#include "script_component.hpp"

private ["_F1", "_h", "_A", "_Cn"];
params["_hL","_hO","_d1","_d2","_f"];

_hO = _hO max 0.01;
_d1	= _d1 max 0.01;
_d2 = _d2 max 0.01;

_F1 = 17.3*(sqrt ((_d1*_d2)/((_f)*(_d1+_d2))));
_h = _hL - _hO;
_A = 0;
if((abs _h) < 2.5) then {
	_A = 0;
} else {
	_Cn = _h/_F1;
	_A = 10 - 20*_Cn;
};
_A
