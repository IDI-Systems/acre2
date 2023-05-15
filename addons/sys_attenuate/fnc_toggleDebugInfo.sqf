#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gives the ability to view attenuation behavior at runtime to diagnose issues with compartment configs.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_attenuate_fnc_toggleDebugInfo;
 *
 * Public: No
 */

private _drawEH = missionNamespace getVariable ["ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH", -1];
if (_drawEH == -1) then {
    ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH = addMissionEventHandler ["Draw3D", {call acre_sys_attenuate_fnc_debugDraw}];
} else {
    removeMissionEventHandler ["Draw3D", ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH];
    ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH = -1;
};
