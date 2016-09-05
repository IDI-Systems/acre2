//fnc_openGui.sqf
#include "script_component.hpp"





disableSerialization;
GVAR(currentRadioId) = _this select 0;
createDialog "PRC148_RadioDialog";
GVAR(PFHId) = ADDPFH(DFUNC(PFH), 0.33, []);
true
