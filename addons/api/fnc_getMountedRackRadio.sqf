/*
 * Author: ACRE2Team
 * Gets the mounted rack radio.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 *
 * Return Value:
 * Mounted radio unique ID, "" if no radio is mounted <STRING>
 *
 * Example:
 * ["ACRE_VRC103_ID_1"] call acre_api_fnc_getMountedRackRadio
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_rackId", ""]];

if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant rack ID provided",_rackId);
};

[_rackId] call EFUNC(sys_rack,getMountedRadio)
