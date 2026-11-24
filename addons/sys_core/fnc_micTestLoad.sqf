#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Microphone test opened: starts metering the microphone and mutes transmitting.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call acre_sys_core_fnc_micTestLoad
 *
 * Public: No
 */

params ["_display"];

uiNamespace setVariable [QGVAR(micTestDisplay), _display];
GVAR(micTestActive) = true;
GVAR(micTest) = createHashMapFromArray [
    ["phase", 0], ["phaseStart", 0], ["lastUpdate", 0],
    ["silent", []], ["typing", []], ["talking", []], ["result", []]
];

["vox:mute", [true]] call EFUNC(sys_io,ext);
["audio:monitor", [true]] call EFUNC(sys_io,ext);

(_display displayCtrl 111) ctrlEnable false;

// Mouse events keep firing while the game is paused; the PFH covers multiplayer.
_display displayAddEventHandler ["MouseHolding", {[] call FUNC(micTestUpdate)}];
_display displayAddEventHandler ["MouseMoving", {[] call FUNC(micTestUpdate)}];
GVAR(micTestPFH) = [{[] call FUNC(micTestUpdate)}, 0, []] call CBA_fnc_addPerFrameHandler;

[] call FUNC(micTestUpdate);
