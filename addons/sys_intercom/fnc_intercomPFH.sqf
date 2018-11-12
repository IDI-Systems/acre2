#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew or passenger.
 * Additionally it checks if a unit is using the vehicle's infantry phone.
 *
 * Arguments:
 * 0: Array of arguments <ARRAY>
 *  0: Player unit <OBJECT>
 *  1: Vehicle with intercom <OBJECT>
 * 1: PFH unique identifier <NUMBER> (unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [[player, vehicle player], 12] call acre_sys_intercom_fnc_intercomPFH
 *
 * Public: No
 */

params ["_param", ""];

_param params ["_player", "_vehicle"];

(_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, INTERCOM_DISCONNECTED]]) params ["_unitInfantryPhone", "_infantryPhoneNetwork"];
private _intercoms = _vehicle getVariable [QGVAR(intercomNames), []];
private _intercomStations = _vehicle getVariable [QGVAR(intercomStations), []];

for "_i" from 0 to ((count _intercoms) - 1) do {
    private _intercomUnits = [];
    private _connectionStatus = INTERCOM_DISCONNECTED;

    // Check if the unit is connected to intercom only if the unit is inside a vehicle
    if (_vehicle == vehicle _player && {[_vehicle, _player, _i] call FUNC(isIntercomAvailable)}) then {
        _connectionStatus = [_vehicle, _player, _i, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
    };

    if (_player == _unitInfantryPhone && {_infantryPhoneNetwork == _i}) then {
        (_vehicle getVariable [QGVAR(infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", "_infantryPhoneMaxDistance"];
        _infantryPhonePosition = _vehicle modelToWorld _infantryPhonePosition;
        private _playerPosition = ASLToAGL (getPosASL _player);
        TRACE_4("Infantry Phone PFH Check",_infantryPhonePosition,_playerPosition,_infantryPhoneMaxDistance,_player distance _infantryPhonePosition);
        // Add an extra meter leeway due to 3d position check height differences and movement
        if (_playerPosition distance _infantryPhonePosition >= _infantryPhoneMaxDistance + 1 || {vehicle _player == _vehicle} || {!alive _player} || {captive _player}) then {
            [_vehicle, _player, 0, _i] call FUNC(updateInfantryPhoneStatus);
            _intercomUnits = [];
        } else {
            // Infantry phones are receive and transmit positions
            _connectionStatus = INTERCOM_RX_AND_TX;
        };
    };

    // Get broadcasting variables
    ((_vehicle getVariable [QGVAR(broadcasting), [false, objNull]]) select _i) params ["_isBroadcasting", "_broadcastingUnit"];

    if (_connectionStatus == INTERCOM_RX_ONLY || {_connectionStatus == INTERCOM_RX_AND_TX}) then {
        if (_isBroadcasting) then {
            // Only the unit that is broadcasting will be on intercom. The rest of the units will be temporarily set to intercom
            _intercomUnits pushBack _broadcastingUnit;
        } else {
            // Gather all units connected to the intercom that can at least transmit
            {
                private _stationConfig = (_vehicle getVariable [_x, []]) select _i;
                private _intercomConfig = (_stationConfig select STATION_INTERCOM_CONFIGURATION_INDEX) select INTERCOM_STATIONSTATUS_CONNECTION;

                // Handle voice/ptt activation
                private _unit = _stationConfig select STATION_INTERCOM_UNIT_INDEX;
                if (!isNull _unit) then {
                    private _voiceActivation = (_stationConfig select STATION_INTERCOM_CONFIGURATION_INDEX) select INTERCOM_STATIONSTATUS_VOICEACTIVATION;
                    // If the unit is not pressing the key to talk to intercom, treat it like not transmitting.
                    if (!_voiceActivation && {_intercomConfig == INTERCOM_TX_ONLY || {_intercomConfig == INTERCOM_RX_AND_TX}} && {!(_unit getVariable [QGVAR(intercomPTT), false])}) then {
                        _intercomConfig = INTERCOM_RX_ONLY;
                    };

                    // Add only those units with seat configuration with transmit capabilities
                    if (_intercomConfig == INTERCOM_RX_AND_TX || {_intercomConfig == INTERCOM_TX_ONLY}) then {
                        _intercomUnits pushBack (_stationConfig select STATION_INTERCOM_UNIT_INDEX);
                    };
                };
            } forEach _intercomStations;

            // Add infantry phone unit
            if (!isNull _unitInfantryPhone && {_infantryPhoneNetwork == _i}) then {
                _intercomUnits pushBackUnique _unitInfantryPhone;
            };
        };
    };

    ACRE_PLAYER_INTERCOM set [_i, _intercomUnits];
};

[_vehicle, ACRE_PLAYER_INTERCOM, _intercoms] call FUNC(updateIntercomUse);
