#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the attenuation between the local player unit and the inputted unit.
 *
 * Arguments:
 * 0: The speaking unit <Object>
 *
 * Return Value:
 * Attenuation <NUMBER>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_getUnitAttenuate
 *
 * Public: No
 */

// this function gets the attenuation value relative *from* the provided unit *to* the acre_player
// e.g. what the local acre_player attenuation scale value is.
// returns 0-1

params ["_speaker"];

private _vehSpeaker = vehicle _speaker;
private _listener = acre_player;
private _vehListener = vehicle _listener;

private _spectatingInsideVehicle = false;
// If we are spectating and in first person view then use the spectating-target's vehicle for attenuation calcs
if (ACRE_IS_SPECTATOR && {cameraView == "INTERNAL"} && {!(cameraOn isKindOf "CaManBase")}) then {
    _listener = cameraOn; // note: cameraOn only provides the vehicle, not the specific unit
    _vehListener = _listener;
    _spectatingInsideVehicle = true;
};

private _attenuate = 0;

if (_vehListener isEqualTo _vehSpeaker) then {
    if (_spectatingInsideVehicle) exitWith {}; // we won't be able to determine the specific compartment

    private _listenerTurnedOut = isTurnedOut _listener;
    private _speakerTurnedOut = isTurnedOut _speaker;

    if (!(_listenerTurnedOut && _speakerTurnedOut)) then {
        private _listenerCompartment = [_listener] call EFUNC(sys_core,getCompartment);
        private _speakerCompartment = [_speaker] call EFUNC(sys_core,getCompartment);

        if (_speakerCompartment != _listenerCompartment) then {
            _attenuate = getNumber (configOf _vehListener >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment);
        };

        if (_speakerTurnedOut || _listenerTurnedOut) then {
            if (_speakerCompartment == _listenerCompartment) then {
                _attenuate = [_listener] call FUNC(getAttenuationTurnedOut);
            } else {
                _attenuate = getNumber (configOf _vehListener >> "ACRE" >> "attenuationTurnedOut" >> _speakerCompartment >> _listenerCompartment);
            };
        };
    };
} else {
    if (_spectatingInsideVehicle || {_vehListener isNotEqualTo _listener}) then {
        private _listenerTurnedOut = isTurnedOut _listener;

        if (!_listenerTurnedOut) then {
            _attenuate = _attenuate + ([_listener] call FUNC(getVehicleAttenuation));
        };
    };

    if (_vehSpeaker isNotEqualTo _speaker) then {
        private _speakerTurnedOut = isTurnedOut _speaker;

        if (!_speakerTurnedOut) then {
            _attenuate = _attenuate + ([_speaker] call FUNC(getVehicleAttenuation));
        };
    };
};

(_attenuate min 1);
