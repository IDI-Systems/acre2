/*
 * Author: ACRE2Team
 * Removes a mounted radio
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Radio to unmount <STRING>
 * 2: Unit with radio to unmount <OBJECT>
 * 3: Remove radio after unmounting <BOOL><OPTIONAL>
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

params [["_rackId", ""], ["_radioId", ""], ["_unit", objNull], ["_deleteRadio", false]];

private _return = false;

if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant rack ID provided: %1",_rackId);
    _return
};

if (!([_radioId] call EFUNC(sys_radio,radioExists))) exitWith {
    WARNING_1("Non existant radio ID provided: %1",_radioId);
    _return
};

if (isNull _unit) exitWith {
    WARNING("Null unit passed as argument");
    _return
};

private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

if (_mountedRadio != _radioId) exitWith {
     WARNING_3("Trying to dismount %1 from Rack ID %1. However, the mounted radio is %3.",_radioId,_rackId,_mountedRadio);
     _return
};

if (_mountedRadio == "") exitWith {
    WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
};

if (_deleteRadio) then {
    [_unit, _mountedRadio] call EFUNC(sys_core,addGear);

    [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    // Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);

    [_unit, _radioId] call EFUNC(sys_core,removeGear);
    _return = true;
} else {
    if (_unit canAdd _mountedRadio) then {
        [_unit, _mountedRadio] call EFUNC(sys_core,addGear);

        [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
        [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

        // Trigger event
        [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);
        _return = true;
    } else {
        // Cannot remove radio
        [localize ELSTRING(sys_rack,unableUnmount), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

_return
