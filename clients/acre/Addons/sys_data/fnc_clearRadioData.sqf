//fnc_clearRadioData.sqf
#include "script_component.hpp"

params ["_radioId"];

HASH_SET(GVAR(radioData),_radioId,nil);