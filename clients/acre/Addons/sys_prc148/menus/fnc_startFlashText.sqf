//fnc_startFlashText.sqf
#include "script_component.hpp"

private["_flashingText", "_id"];
params ["_display", "_row", "_range"];

_flashingText = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingText", []);
_id = (count _flashingText);
_flashingText set[_id, [_row, _range]];
SCRATCH_SET(GVAR(currentRadioId), "flashingText", _flashingText);
hintSilent format["GVAR(currentRadioId): %1", GVAR(currentRadioId)];
_id;
