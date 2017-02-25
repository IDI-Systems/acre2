/*
 * Author: ACRE2Team
 * Calls the infantry phone.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_intercom_fnc_infantryPhoneSoundCall
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

(_vehicle getVariable [QGVAR(infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", ""];
private _position = AGLToASL (_vehicle modelToWorld _infantryPhonePosition); // ACRE_LISTENER_POS is in ASL coordinates.
private _direction = getPosASL _vehicle;
private _attenuate = [_vehicle] call EFUNC(sys_attenuate,getUnitAttenuate);
_attenuate = (1 - _attenuate)^3; // Same attenuation as in EFUNC(sys_radio,playRadioSound)
private _volume = 1;
private _args = [_position, ACRE_LISTENER_POS, acre_player];
private _volumeModifier = _args call EFUNC(sys_core,findOcclusion);
_volumeModifier = _volumeModifier^3; // Same volume modifier as in EFUNC(sys_radio,playRadioSound)

// The infantry phone of the vehicle is ringing
_vehicle setVariable [QGVAR(isInfantryPhoneCalling), true, true];

private _ringing = {
    params ["_args", "_pfhID"];
    _args params ["_vehicle", "_position", "_direction", "_volume"];

    private _unitInfantryPhone = _vehicle getVariable [QGVAR(unitInfantryPhone), objNull];
    private _isCalling = _vehicle getVariable [QGVAR(isInfantryPhoneCalling), false];

    private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
    {
        _crew pushBackUnique (_vehicle turretUnit _x);
    } forEach (allTurrets [_vehicle, false]);
    _crew = _crew - [objNull];

    private _noCrew = false;
    if (count _crew == 0) then {
        _noCrew = true;
    };

    if ((isNull _unitInfantryPhone) && {_isCalling} && {alive _vehicle} && {!_noCrew}) then {
        TRACE_5("Infantry Phone Calling PFH Check",_vehicle,acre_player,_position,_direction,_volume);
        ["Acre_GenericBeep", _position, _direction, _volume, true] call EFUNC(sys_sounds,playSound);
    } else {
        // A unit picked up the phone. Reset isCalling variable.
        if (_isCalling) then {
            _vehicle setVariable [QGVAR(isInfantryPhoneCalling), false, true];
        };
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };
};

[_ringing, 1, [_vehicle, _position, _direction, _volume*_volumeModifier*_attenuate]] call CBA_fnc_addPerFrameHandler;
