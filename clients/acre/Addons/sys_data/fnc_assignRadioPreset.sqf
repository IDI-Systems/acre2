//fnc_assignRadioPreset.sqf
#include "script_component.hpp"

params ["_class", "_presetName"];

HASH_SET(GVAR(assignedRadioPresets),_class,_presetName);