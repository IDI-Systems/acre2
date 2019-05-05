#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the ACRE radios have initialized. This means that they have been replaced with ID specified radios.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * All radios on unit are initialized <BOOLEAN>
 *
 * Example:
 * _status = [] call acre_api_fnc_isInitialized;
 *
 * Public: Yes
 */

if (!hasInterface) exitWith {false}; //Exit on server.

params [
    ["_unit", acre_player, [objNull]]
];

// Is initialized if the unit has no base radio, hasBaseRadio also can not return nil
// and also check that we don't return true if the unit has an ItemRadio as ItemRadio is also a base radio
!isNull _unit && {!([_unit] call FUNC(hasBaseRadio))} && {!([_unit, "ItemRadio"] call EFUNC(sys_core,hasItem))};

