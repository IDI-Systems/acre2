#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the mounted rack radio.
 *
 * Arguments:
 * 0: Rack unique ID <STRING>
 *
 * Return Value:
 * Mounted radio unique ID, "" if no radio is mounted <STRING>
 *
 * Example:
 * ["ACRE_VRC103_ID_1"] call acre_api_fnc_getMountedRackRadio
 *
 * Public: Yes
 */

params [
    ["_rackId", "", [""]],
    ["_returnBaseClass", false, [true]]
];

if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant rack ID provided: %1",_rackId);
};

private _return = "";
if (_returnBaseClass) then {
    private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);
    if (_radioId != "") then {
        _return = [_radioId] call FUNC(getBaseRadio);
    };
} else {
    _return = [_rackId] call EFUNC(sys_rack,getMountedRadio);
};

_return
