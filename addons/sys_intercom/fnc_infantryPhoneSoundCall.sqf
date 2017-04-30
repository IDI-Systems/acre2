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

// The infantry phone of the vehicle is ringing
_vehicle setVariable [QGVAR(isInfantryPhoneCalling), true, true];

private _duration = INFANTRY_PHONE_SOUND_PFH_DURATION;
private _customSound = _vehicle getVariable [QGVAR(infPhoneCustomRinging), []];
if (count _customSound > 0) then {
    _duration = _customSound select 1;
};

[FUNC(infantryPhoneRingingPFH), _duration, [_vehicle, _infantryPhonePosition]] call CBA_fnc_addPerFrameHandler;
