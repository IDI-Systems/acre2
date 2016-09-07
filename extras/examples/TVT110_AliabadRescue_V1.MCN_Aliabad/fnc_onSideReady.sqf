#include "script_component.hpp"

private["_side"];

_side = _this select 0;
switch _side do {
	case west: {
		titleFadeOut 0.1;
		titleText ["BLUFOR has signalled that they are ready to begin.", "PLAIN", 3];
		hint "Blufor is ready";
	};
	case east: {
		titleFadeOut 0.1;
		titleText ["OPFOR has signalled that they are ready to begin.", "PLAIN", 3];
		hint "Opfor is ready";
	};
};

//
// Server side only
//
if(!isServer) exitWith { true };

if(!(_side in GVAR(sideReady))) then { 
	PUSH(GVAR(sideReady), _side);
};
