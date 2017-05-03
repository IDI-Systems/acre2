/*
 * Author: ACRE2Team
 * Ringing handler.
 *
 * Arguments:
 * 0: Array with vehicle, position, direction and volume entries <ARRAY>
 * 1: Per frame handler ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[cursorTarget, [0,0,0], [0,1,0], 1], pfhID] call acre_sys_intercom_fnc_infantryPhoneRingingPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_args", "_pfhID"];
_args params ["_vehicle", "_infantryPhonePosition"];

(_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, objNull]]) params ["_unitInfantryPhone", ""];
private _isCalling = _vehicle getVariable [QGVAR(isInfantryPhoneCalling), false];

private _crew = crew _vehicle select {[_vehicle, _x] call FUNC(isInfantryPhoneSpeakerAvailable)};

private _noCrew = false;
if (count _crew == 0) then {
    _noCrew = true;
};

if ((isNull _unitInfantryPhone) && {_isCalling} && {alive _vehicle} && {!_noCrew}) then {
    private _position = AGLToASL (_vehicle modelToWorld _infantryPhonePosition); // ACRE_LISTENER_POS is in ASL coordinates
    TRACE_4("Infantry Phone Calling PFH Check",_vehicle,acre_player,_position,_volume);

    private _soundFile = INFANTRY_PHONE_SOUNDFILE;
    private _volume = INFANTRY_PHONE_VOLUME;
    private _soundPitch = INFANTRY_PHONE_SOUNDPITCH;
    private _distance = INFANTRY_PHONE_MAX_DISTANCE;
    private _customSound = _vehicle getVariable [QGVAR(infPhoneCustomRinging), []];
    if (count _customSound > 0) then {
        _soundFile = _customSound select 0;
        _volume = _customSound select 2;
        _soundPitch = _customSound select 3;
        _distance = _customSound select 4;
    };
    playSound3D [_soundFile, objNull, false, _position, _volume*10, _soundPitch, _distance];
} else {
    // A unit picked up the phone. Reset isCalling variable
    if (_isCalling) then {
        _vehicle setVariable [QGVAR(isInfantryPhoneCalling), false, true];
    };
    [_pfhID] call CBA_fnc_removePerFrameHandler;
};
