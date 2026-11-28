#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * 0: Group index (0-based index) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_godmode_fnc_handlePttKeyPressUp
 *
 * Public: No
 */

params ["_group"];

if !([_group] call FUNC(accessAllowed)) exitWith { false };

// After the PTT release delay, unless pressed again meanwhile.
[QGVAR(ptt), {
    [QGVAR(stopSpeaking), [EGVAR(sys_core,ts3id)], GVAR(targetUnits)] call CBA_fnc_targetEvent;
    GVAR(targetUnits) = [];

    ["god"] call EFUNC(sys_core,stopTransmission);
    GVAR(speaking) = false;

#ifndef ALLOW_EMPTY_TARGETS
    if (GVAR(targetUnits) isNotEqualTo []) then {
        #ifndef TEST_SELF_RX
        ["Acre_GodPingOff", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false, false] call EFUNC(sys_sounds,playSound);
        #endif
    };
#endif

    [QGVAR(tx)] call EFUNC(sys_list,hideHint);
}] call EFUNC(sys_core,pttReleased);

true
