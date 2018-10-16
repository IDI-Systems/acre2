#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Unmounts the radio in the rack and places it on the unit.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_VRC110_ID_1",acre_player] call acre_sys_rack_fnc_unmountRadio
 *
 * Public: No
 */

params ["_rackId", "_unit"];

private _mountedRadio = GET_STATE_RACK(_rackId,"mountedRadio");

if (_mountedRadio == "") exitWith {
    WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
};

if (_unit canAdd _mountedRadio) then {
    [_unit, _mountedRadio] call EFUNC(sys_core,addGear);

    SET_STATE_RACK(_rackId,"mountedRadio","");
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    //Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
} else {
    [localize LSTRING(unableUnmount), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};
