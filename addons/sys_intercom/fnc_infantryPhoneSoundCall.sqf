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

[FUNC(infantryPhoneRingingPFH), 2.25, [_vehicle, _infantryPhonePosition]] call CBA_fnc_addPerFrameHandler;
