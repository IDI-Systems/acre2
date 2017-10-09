/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew or passenger.
 * Additionally it checks if a unit is using the vehicle's infantry phone.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_intercom_fnc_intercomPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_param", "_handle"];

_param params ["_player", "_vehicle"];

private _unitsIntercom = _vehicle getVariable [QGVAR(unitsIntercom), []];
_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, NO_INTERCOM]] params ["_unitInfantryPhone", "_infantryPhoneNetwork"];
private _intercoms = _vehicle getVariable [QGVAR(intercomNames), []];

for "_i" from 0 to ((count _intercoms) - 1) do {

    // Check if the seat configuration. If the seat has an active intercom connection, connect automatically to it. Disconnect otherwise.
    private _intercomUnits = +(_unitsIntercom select _i);
    private _changes = false;

    if (_player == _unitInfantryPhone) then {
        // Unit is outside the vehicle
        if (!(_player in _intercomUnits) && (_infantryPhoneNetwork == _i)) then {
            _intercomUnits pushBackUnique _player;
            _changes = true;
        } else {
            if (_infantryPhoneNetwork != _i) then {
                _intercomUnits = _intercomUnits - [_player];
                _changes = true;
            };
            (_vehicle getVariable [QGVAR(infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", "_infantryPhoneMaxDistance"];
            _infantryPhonePosition = _vehicle modelToWorld _infantryPhonePosition;
            private _playerPosition = ASLToAGL (getPosASL _player);
            TRACE_4("Infantry Phone PFH Check",_infantryPhonePosition,_playerPosition,_infantryPhoneMaxDistance,_player distance _infantryPhonePosition);
            // Add an extra meter leeway due to 3d position check height differences and movement
            if (_playerPosition distance _infantryPhonePosition >= _infantryPhoneMaxDistance + 1 || {vehicle _player == _vehicle} || {!alive _player} || {captive _player}) then {
                _intercomUnits = _intercomUnits - [_player];
                [_vehicle, _player, 0, _i] call FUNC(updateInfantryPhoneStatus);
                _changes = true;
            };
        };
    };

    // Update intercom connection status
    if (_changes) then {
        _unitsIntercom set [_i, _intercomUnits];
        _vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom, true];
        _unitsIntercom = _vehicle getVariable [QGVAR(unitsIntercom), []];
    };

    if (_player in _intercomUnits) then {
        ACRE_PLAYER_INTERCOM set[_i, _intercomUnits];
    } else {
        ACRE_PLAYER_INTERCOM set [_i, []];
    };

    _intercomUnits = [];
};
