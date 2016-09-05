//fnc_getExternalAudioPosition.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];
private ["_obj", "_pos"];

_obj = RADIO_OBJECT(_radioId);
_pos = getPosASL _obj;
if(_obj isKindOf "Man") then {
	_pos = ATLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
};

_pos;

