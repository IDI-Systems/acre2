//fnc_updateSelf.sqf
#include "script_component.hpp"

// ref bug: http://feedback.arma3.com/view.php?id=15580
private _projectPos1 = ATLtoASL positionCameraToWorld [0,0,0];

private _projectPos2 = ATLtoASL positionCameraToWorld [0,0,1];

ACRE_LISTENER_DIR = _projectPos2 vectorDiff _projectPos1;

if(!ACRE_IS_SPECTATOR) then {
	ACRE_LISTENER_POS = eyePos acre_player;
} else {
	ACRE_LISTENER_POS = _projectPos1;
};
_additionalValues = [([] call FUNC(getSpeakingLanguageId))];
CALL_RPC("updateSelf", ACRE_LISTENER_POS + ACRE_LISTENER_DIR + _additionalValues);
