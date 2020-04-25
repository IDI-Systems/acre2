#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles multi push-to-talk keybind press (to be ran within PFH).
 *
 * Arguments:
 * 0: Arguments array <ARRAY>
 *  0: Broadcasting radio unique ID <STRING>
 *  1: Multi-PTT-Key pressed <BOOL>
 * 1: PerFrameHandler ID <NUMBER> (unused)
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_intercom_fnc_handlePttKeyPressUpPFH
 *
 * Public: No
 */

params ["_args", ""];
_args params ["_broadcastRadio", "_keyPressed"];

if (_keyPressed) then {
    [GVAR(delayReleasePTT_Handle)] call CBA_fnc_removePerFrameHandler;
    GVAR(delayReleasePTT_Handle) = nil;

    if (GVAR(pttKeyDown)) then {
        [_broadcastRadio, "handlePTTUp"] call EFUNC(sys_data,transEvent);
        ["stopIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
        GVAR(pttKeyDown) = false;
    };
} else {
    _args set [1, true];
    _this set [0, _args];
};
