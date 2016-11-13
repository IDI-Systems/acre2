/*
 * Author: ACRE2Team
 * Mount radio classname
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * RETURN VALUE <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_mountRadio;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId","_radioId",["_unit",objNull]];

if (!isNull _unit) then {
    [_unit, _radioId] call EFUNC(lib,removeGear);
};

//Stash Radio
SET_STATE_RACK(_rackId,"mountedRadio",_radioId);

//Send event to do rack specific actions.
[_rackId, "mountRadio", _radioId] call EFUNC(sys_data,dataEvent);