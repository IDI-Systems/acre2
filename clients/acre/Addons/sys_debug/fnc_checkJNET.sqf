//fnc_testSetup.sqf
#include "script_component.hpp"

private["_jnetLoaded", "_ret"];
_jnetLoaded = false;

_ret = "jnet" callExtension "getCurrentServer:";
diag_log text format["JNET Response: '%1'", _ret];
if(_ret != "") then {
	_jnetLoaded = true;
};
_jnetLoaded