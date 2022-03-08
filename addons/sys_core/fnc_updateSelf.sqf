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
private _projectPos = AGLtoASL positionCameraToWorld [0, 0, 0];

if (EGVAR(sys_zeus,zeusCommunicateViaCamera) && FUNC(inZeus)) then {
    ACRE_LISTENER_DIR = eyeDirection player;
} else {
    ACRE_LISTENER_DIR = (AGLtoASL positionCameraToWorld [0, 0, 1]) vectorDiff _projectPos;
};

if (ACRE_IS_SPECTATOR) then {
    ACRE_LISTENER_POS = _projectPos;
} else {
    ACRE_LISTENER_POS = acre_player modelToWorldVisualWorld (acre_player selectionPosition "pilot");
};

private _height = ACRE_LISTENER_POS param [2, 1];
if (_height < 0) then {
    ACRE_LISTENER_DIVE = 1;
} else {
    ACRE_LISTENER_DIVE = 0;
};

private _additionalValues = [[] call FUNC(getSpeakingLanguageId)];
private _updateSelf = [];
_updateSelf append ACRE_LISTENER_POS;
_updateSelf append ACRE_LISTENER_DIR;
_updateSelf append _additionalValues;

["updateSelf", _updateSelf] call EFUNC(sys_rpc,callRemoteProcedure);
