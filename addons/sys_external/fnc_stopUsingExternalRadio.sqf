/*
 * Author: ACRE2Team
 * Stop using an external radio, either returning it to the owner or giving it to another player. If target
 * is skipped, a default action to return to the owner is taken
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: New end user/original owner <OBJECT>(Optional)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", cursorTarget] call acre_sys_external_stopUsingExternalRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_target"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);

if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
    // simulate a key up event to end the current transmission
    [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
};

ACRE_ACTIVE_EXTERNAL_RADIOS = ACRE_ACTIVE_EXTERNAL_RADIOS - [_radioId];
[1] call EFUNC(sys_list,cycleRadios); // Change active radio

[format [localize LSTRING(hintReturn), [_radioId] call EFUNC(api,getBaseClass), _owner]] call EFUNC(sys_core,displayNotification);

if (_target == _owner) then {
    // Give radio back to the owner
    [_radioId, "setState", ["isUsedExternally", [false, objNull]]] call EFUNC(sys_data,dataEvent);
} else {
    // Give radio to another player
    [_radioId, _target] remoteExecCall [QFUNC(startUsingExternalRadio), _target, false];
};
