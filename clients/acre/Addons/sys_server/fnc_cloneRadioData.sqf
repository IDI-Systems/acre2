//fnc_cloneRadioData.sqf
#include "script_component.hpp"

params ["_radioId", "_radioData"];

HASH_SET(acre_sys_data_radioData, _radioId, _radioData);
