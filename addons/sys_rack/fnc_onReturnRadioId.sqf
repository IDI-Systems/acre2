/*
 * Author: ACRE2Team
 * Used to catch the return for a radio being initialized in a Rack
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_rack_fnc_onReturnRadioId
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackObject", "_class", "_returnIdNumber"];

private _dataHash = HASH_CREATE;

HASH_SET(EGVAR(sys_data,radioData),_class,_dataHash);
private _idRelation = [_rackObject, _rackObject];
HASH_SET(EGVAR(sys_server,objectIdRelationTable),_class,_idRelation);

private _vehicle = _rackObject;
if (!isNull (attachedTo _rackObject)) then { _vehicle = attachedTo _rackObject; };
 //TODO: test this works.
private _crewPlayers = (crew _vehicle) select {isPlayer _x};
private _condition = false;
if (count _crewPlayers > 0) then {
    if (local (_crewPlayers select 0)) then {
        _condition = true;
    };
} else {
    // FallBack to server.
    if (isServer) then {
        _condition = true;
    };
};

if (_condition) then {
    private _baseRadio = BASECLASS(_class);
    private _rackId = typeOf _rackObject;
    if (_baseRadio == GET_STATE_RACK(_rackId,"mountedRadio")) then {
        // Add a new radio based on the id we just got
        TRACE_2("Adding radio", _class, _baseRadio);

        // initialize the new radio
        private _preset = [BASECLASS(_class)] call EFUNC(sys_data,getRadioPresetName);
        [_class, _preset] call EFUNC(sys_radio,initDefaultRadio);

        //Mount the radio into the rack.
        [_rackId, _class] call FUNC(mountRadio);
    }  else {
        WARNING_3("Radio ID %1 for a vehicle rack was returned for a non-existent base class (%2).",_class,_baseRadio);
    };

    ["acre_acknowledgeId", [_class, acre_player]] call CALLSTACK(CBA_fnc_globalEvent);
};
