/*
 * Author: ACRE2Team
 * Stop using an external radio, either returning it to the owner or giving it to another player.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 2: New end user/original owner <OBJECT>
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

if (_target == _owner) then {
    // Give radio back to the owner
    [_radioId, "setState", ["isUsedExternally", [false, nil, nil]]] call EFUNC(sys_data,dataEvent);
} else {
    // Give radio to another player
    [_radioId, _owner, _target] remoteExecCall [QFUNC(startUsingExternalRadio), _target, false];
};

ACRE_ACTIVE_EXTERNAL_RADIOS = ACRE_ACTIVE_EXTERNAL_RADIOS - [_radioId];
