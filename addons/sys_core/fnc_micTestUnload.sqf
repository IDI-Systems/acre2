#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Microphone test closed: stops metering and restores the microphone.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_micTestUnload
 *
 * Public: No
 */

GVAR(micTestActive) = false;
[GVAR(micTestPFH)] call CBA_fnc_removePerFrameHandler;
uiNamespace setVariable [QGVAR(micTestDisplay), displayNull];

["audio:monitor", [false]] call EFUNC(sys_io,ext);
["vox:mute", [GVAR(micMuted) || {IS_MUTED(acre_player)}]] call EFUNC(sys_io,ext);
