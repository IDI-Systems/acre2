/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

// this function gets the attenuation value relative *from* the provided unit *to* the acre_player
// e.g. what the local acre_player attenuation scale value is.
// returns 0-1
private["_temp"];
params["_unitVehicle","_positionName"];

TRACE_1("enter", _this);

private _attenuate = 0;

// now, one of us is in a vehicle. We need to search both and see what our outide attenuation values are
// aproppriately if we are in a different vehicle
private _playerVehicle = vehicle acre_player;

if( !(_unitVehicle != _playerVehicle) ) then { // We are NOT in the same vehicle, use outide attenuation value
    if(_playerVehicle != acre_player) then { // wee are in a vehicle
        // get our own outside attenuation value
        _temp = [_playerVehicle, acre_player] call FUNC(getVehicleOutsideAttenuate);
        TRACE_2("", _attenuate, _temp);
        if(!(isTurnedOut acre_player)) then {
            _attenuate = _attenuate + _temp;
        };
    };

    _temp = [_unitVehicle, _positionName] call FUNC(getVehicleOutsideAttenuate);
} else { // crew member attenuation code goes here
    _attenuate = [_unitVehicle, acre_player, _positionName] call FUNC(getVehicleCrewAttenuate);
};

TRACE_3("returning attenuate", _playerVehicle, _unitVehicle, _attenuate);

_attenuate
