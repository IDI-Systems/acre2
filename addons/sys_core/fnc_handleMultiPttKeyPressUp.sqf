/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

DFUNC(doHandleMultiPttKeyPressUp) = {
    params ["_args"];
    if( (_args select 1) ) then {
        [GVAR(delayReleasePTT_Handle)] call EFUNC(sys_sync,perFrame_remove);
        GVAR(delayReleasePTT_Handle) = nil;

        if(GVAR(pttKeyDown)) then {
            [(_args select 0), "handlePTTUp"] call EFUNC(sys_data,transEvent);
            ["stopRadioSpeaking", ","] call EFUNC(sys_rpc,callRemoteProcedure);
            GVAR(pttKeyDown) = false;
        };
    } else {
        _args set[1, true];
        _this set[0,_args];
    };
};

// acre_player sideChat format["Key Up: %1", _this];

if(ACRE_ACTIVE_PTTKEY != -2) then {
    ACRE_ACTIVE_PTTKEY = -2;
    if(ACRE_BROADCASTING_RADIOID != "") then {
        GVAR(delayReleasePTT_Handle) = ADDPFH(DFUNC(doHandleMultiPttKeyPressUp), ACRE_PTT_RELEASE_DELAY, ARR_2(ACRE_BROADCASTING_RADIOID,false));
    };
};
true
