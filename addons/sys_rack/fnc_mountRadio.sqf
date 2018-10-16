#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Mount radio to a specified rack
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 * 1: Unique radio ID <STRING>
 * 2: Unit <OBJECT><OPTIONAL> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_VRC103_ID_1","ACRE_PRC117F_ID_1"] call acre_sys_rack_fnc_mountRadio
 *
 * Public: No
 */

params ["_rackId", "_radioId", ["_unit",objNull]];

if (!isNull _unit) then {
    [_unit, _radioId] call EFUNC(sys_core,removeGear);
};

//Stash Radio
SET_STATE_RACK(_rackId,"mountedRadio",_radioId);

//Send event to do rack specific actions.
[_rackId, "mountRadio", _radioId] call EFUNC(sys_data,dataEvent);
