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

if (_vehListener == _vehSpeaker) then {
    if (_spectatingInsideVehicle) exitWith {}; // we won't be able to determine the specific compartment
    private _listenerTurnedOut = isTurnedOut _listener;
    private _speakerTurnedOut = isTurnedOut _speaker;
    if (!(_listenerTurnedOut && _speakerTurnedOut)) then {

        private _listenerCompartment = [_listener] call EFUNC(sys_core,getCompartment);
        private _speakerCompartment = [_speaker] call EFUNC(sys_core,getCompartment);
        if (_speakerCompartment != _listenerCompartment) then {
            // acre_player sideChat format["1 lc: %1 sc: %2 %3", _listenerCompartment, _speakerCompartment, (getNumber (configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment))];
            _attenuate = ((getNumber (configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment)));
        };
        if (_speakerTurnedOut || _listenerTurnedOut) then {
            // acre_player sideChat format["2 lc: %1 sc: %2 %3", _listenerCompartment, _speakerCompartment, (getNumber (configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment))];
            _attenuate = ([_listener] call FUNC(getVehicleAttenuation))*0.5;
        };
    };
} else {
    if (_spectatingInsideVehicle || {_vehListener != _listener}) then {
        private _listenerTurnedOut = isTurnedOut _listener;
        if (!_listenerTurnedOut) then {
            // acre_player sideChat format["1 %1 %2", _attenuate, (1-(getNumber (configFile >> "CfgVehicles" >> (typeOf (vehicle _listener)) >> "insideSoundCoef")))];
            _attenuate = _attenuate + ([_listener] call FUNC(getVehicleAttenuation));
        };
    };
    if (_vehSpeaker != _speaker) then {
        private _speakerTurnedOut = isTurnedOut _speaker;
        if (!_speakerTurnedOut) then {
            // acre_player sideChat format["2 %1 %2", _attenuate, (1-(getNumber (configFile >> "CfgVehicles" >> (typeOf (vehicle _speaker)) >> "insideSoundCoef")))];
            _attenuate = _attenuate + ([_speaker] call FUNC(getVehicleAttenuation));
        };
    };
};

(_attenuate min 1);
