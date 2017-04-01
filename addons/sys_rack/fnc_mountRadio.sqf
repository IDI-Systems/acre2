/*
 * Author: ACRE2Team
 * Mount radio to a specified rack
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_VRC103_ID_1","ACRE_PRC117F_ID_1"] call acre_sys_rack_fnc_mountRadio;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "_radioId", ["_unit",objNull]];

if (!isNull _unit) then {
    [_unit, _radioId] call EFUNC(sys_core,removeGear);
};

//Stash Radio
SET_STATE_RACK(_rackId,"mountedRadio",_radioId);

//Send event to do rack specific actions.
[_rackId, "mountRadio", _radioId] call EFUNC(sys_data,dataEvent);
