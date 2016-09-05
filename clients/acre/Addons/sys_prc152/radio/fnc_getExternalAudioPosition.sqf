//fnc_getExternalAudioPosition.sqf
#include "script_component.hpp"

private ["_obj", "_pos"];
params["_radioId", "_event", "_eventData", "_radioData"];

_obj = RADIO_OBJECT(_radioId);
_pos = getPosASL _obj;
if(_obj isKindOf "Man") then {
	_pos = ATLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
};

_pos;

