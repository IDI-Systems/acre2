//fnc_PFH.sqf
#include "script_component.hpp"

private ["_flashingText", "_flashingState", "_color", "_row", "_x", "_range", "_i", "_textCtrl", "_display", "_animations"];
_display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));
_flashingText = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingText", []);
_flashingState = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingTextState", false);
_color = [0,0,0,1];
if(_flashingState) then {
	_color = [123/255,179/255,118/255,1];
};

{
	_row = _x select 0;
	_range = _x select 1;
	
	
	for "_i" from (_range select 0) to (_range select 1) do {
		_textCtrl = _display displayCtrl (_row+_i);
		_textCtrl ctrlSetTextColor _color;
		_textCtrl ctrlCommit 0;
	};
	
} forEach _flashingText;
SCRATCH_SET(GVAR(currentRadioId), "flashingTextState", !_flashingState);

_animations = SCRATCH_GET_DEF(GVAR(currentRadioId), "animations", []);

{
	[(_x select 0), (_x select 1)] call (_x select 2);
} forEach _animations;

