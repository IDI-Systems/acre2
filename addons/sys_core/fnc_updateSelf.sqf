#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the position and viewing direction of the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_updateSelf
 *
 * Public: No
 */

// ref bug: http://feedback.arma3.com/view.php?id=15580
private _projectPos1 = ATLtoASL positionCameraToWorld [0,0,0];

private _projectPos2 = ATLtoASL positionCameraToWorld [0,0,1];

ACRE_LISTENER_DIR = _projectPos2 vectorDiff _projectPos1;

if (!ACRE_IS_SPECTATOR) then {
    ACRE_LISTENER_POS = eyePos acre_player;
} else {
    ACRE_LISTENER_POS = _projectPos1;
};

private _height = ACRE_LISTENER_POS param [2, 1];
if (_height < 0) then {
    ACRE_LISTENER_DIVE = 1;
} else {
    ACRE_LISTENER_DIVE = 0;
};

private _additionalValues = [([] call FUNC(getSpeakingLanguageId))];
CALL_RPC("updateSelf", ACRE_LISTENER_POS + ACRE_LISTENER_DIR + _additionalValues);
