//fnc_getRemoteRadioList.sqf
#include "script_component.hpp"

params["_user"];

private _return = _user getVariable[QGVAR(radioIdList), []];

_return
