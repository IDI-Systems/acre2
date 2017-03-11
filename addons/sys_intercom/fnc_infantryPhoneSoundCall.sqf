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

[QGVAR(infPhoneEventCalling), [_vehicle, _position, _direction, _volume*_volumeModifier*_attenuate]] call CBA_fnc_globalEvent;
