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
    if ( (_args select 1) ) then {
        [GVAR(delayReleasePTT_Handle)] call CBA_fnc_removePerFrameHandler;
        GVAR(delayReleasePTT_Handle) = nil;

        if (GVAR(pttKeyDown)) then {
            [(_args select 0), "handlePTTUp"] call EFUNC(sys_data,transEvent);
            ["stopRadioSpeaking", ","] call EFUNC(sys_rpc,callRemoteProcedure);
            GVAR(pttKeyDown) = false;
            [ACRE_BROADCASTING_NOTIFICATION_LAYER] call EFUNC(sys_list,hideHint);
        };
    } else {
        _args set[1, true];
        _this set[0,_args];
    };
};

// acre_player sideChat format["Key Up: %1", _this];

if (ACRE_ACTIVE_PTTKEY != -2) then {
    ACRE_ACTIVE_PTTKEY = -2;
    if (ACRE_BROADCASTING_RADIOID != "") then {
        GVAR(delayReleasePTT_Handle) = ADDPFH(DFUNC(doHandleMultiPttKeyPressUp), ACRE_PTT_RELEASE_DELAY, [ARR_2(ACRE_BROADCASTING_RADIOID,false)]);
    };
};
true
