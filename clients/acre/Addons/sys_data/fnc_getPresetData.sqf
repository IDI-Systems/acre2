//fnc_getPresetData.sqf
#include "script_component.hpp"

params ["_radioType", "_presetName"];

// diag_log text format["getting preset data for: %1", _this];
private _radioPresets = HASH_GET(GVAR(radioPresets),_radioType);
private _presetData = HASH_GET(_radioPresets,_presetName);
_presetData

