#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle key up of multiPttKeyPress.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_handleMultiPttKeyPressUp
 *
 * Public: No
 */

DFUNC(doHandleMultiPttKeyPressUp) = {
    params ["_args"];
    _args params ["_radioId", "_release"];
    if (_release) then {
        [GVAR(delayReleasePTT_Handle)] call CBA_fnc_removePerFrameHandler;
        GVAR(delayReleasePTT_Handle) = nil;

        if (GVAR(pttKeyDown)) then {
            [_radioid, "handlePTTUp"] call EFUNC(sys_data,transEvent);
            ["stopRadioSpeaking", ","] call EFUNC(sys_rpc,callRemoteProcedure);
            GVAR(pttKeyDown) = false;
            [format ["acre_broadcast_%1", _radioId]] call EFUNC(sys_list,hideHint);
        };
    } else {
        _args set [1, true];
        _this set [0, _args];
    };
};

if (ACRE_ACTIVE_PTTKEY != -2) then {
    ACRE_ACTIVE_PTTKEY = -2;
    if (ACRE_BROADCASTING_RADIOID != "") then {
        GVAR(delayReleasePTT_Handle) = [DFUNC(doHandleMultiPttKeyPressUp), ACRE_PTT_RELEASE_DELAY, [ACRE_BROADCASTING_RADIOID, false]] call CBA_fnc_addPerFrameHandler;
    };
};

true
