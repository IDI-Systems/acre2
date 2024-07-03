#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to catch the return for a radio being initialized in a Rack
 *
 * Arguments:
 * 0: Rack object <OBJECT>
 * 1: Rack class <STRING>
 * 2: Unique ID number <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_rack_fnc_onReturnRadioId
 *
 * Public: No
 */

params ["_rackObject", "_class", "_returnIdNumber"];

private _dataHash = HASH_CREATE;

HASH_SET(EGVAR(sys_data,radioData),_class,_dataHash);
private _idRelation = [_rackObject, _rackObject];
HASH_SET(EGVAR(sys_server,objectIdRelationTable),_class,_idRelation);

private _vehicle = _rackObject;
_vehicle = _rackObject getVariable [QGVAR(rackVehicle), _rackObject];

// To further check. No isses found.
private _crewPlayers =  [_vehicle] call EFUNC(sys_core,getPlayersInVehicle);
private _condition = false;

if (_crewPlayers isNotEqualTo []) then {
    if (local (_crewPlayers select 0)) then {
        _condition = true;
    };
} else {
    // Rack is initialised through an API function. Get the player that matched the condition
    // in order to initialise the rack.
    private _player = _vehicle getVariable [QGVAR(initPlayer), objNull];
    if (isNull _player) then {
        _player = ([] call CBA_fnc_players) select 0;
    };

    if (local _player) then {
        _condition = true;
    };
};

if (_condition) then {
    private _baseRadio = BASECLASS(_class);
    private _rackId = typeOf _rackObject;

    if (_baseRadio == GET_STATE_RACK(_rackId,"mountedRadio")) then {
        // Add a new radio based on the id we just got
        TRACE_2("Adding radio",_class,_baseRadio);

        // Initialize the new radio
        private _preset = _vehicle getVariable [QGVAR(vehicleRacksPreset), ""];
        if (_preset isEqualTo "") then {
            _preset = [BASECLASS(_class)] call EFUNC(sys_data,getRadioPresetName);
        };
        [_class, _preset] call EFUNC(sys_radio,initDefaultRadio);

        //Mount the radio into the rack.
        [_rackId, _class] call FUNC(mountRadio);
    }  else {
        WARNING_2("Radio ID %1 for a vehicle rack was returned for a non-existent base class (%2).",_class,_baseRadio);
    };

    ["acre_acknowledgeId", [_class, acre_player]] call CALLSTACK(CBA_fnc_globalEvent);
};
