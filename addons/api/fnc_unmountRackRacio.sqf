/*
 * Author: ACRE2Team
 * Removes a mounted radio
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Radio to mount <STRING>
 * 2: Unit with radio to mount <OBJECT><OPTIONAL>
 *
 * Return Value:
 * Setup succesful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F_ID_1", acre_player] call acre_api_fnc_mountRackRadio
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_rackId", ""], ["_unit", objNull]];

if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant rack ID provided",_rackId);
};

private _mountedRadio = GET_STATE_RACK(_rackId,"mountedRadio");

if (_mountedRadio == "") exitWith {
    WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
};

if (!isNull _unit) then {
    if (_unit canAdd _mountedRadio) then {
        [_unit, _mountedRadio] call EFUNC(sys_core,addGear);

        SET_STATE_RACK(_rackId,"mountedRadio","");
        [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

        // Trigger event
        [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
    } else {
        // Cannot remove radio
        [localize ELSTRING(sys_rack,unableUnmount), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
} else {
    SET_STATE_RACK(_rackId,"mountedRadio","");
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    // Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);

    // Remove radio ID

};
