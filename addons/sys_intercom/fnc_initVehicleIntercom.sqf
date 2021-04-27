#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises all intercoms in a vehicle, as well as the infantry phone.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_initVehicleIntercom
 *
 * Public: No
 */

params ["_vehicle"];

private _config = configOf _vehicle;

private _intercoms = configProperties [_config >> "AcreIntercoms", "isClass _x", true];

if (_intercoms isEqualTo []) exitWith {};

[_vehicle, _intercoms] call FUNC(configIntercom);

if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_interact_menu")}) then {
    [_vehicle] call FUNC(intercomAction);
};

// Exit if object has no infantry phone
if (getNumber (_config >> "acre_hasInfantryPhone") == 1) then {
    [_vehicle] call FUNC(configInfantryPhone);
    // UAV units should not have infantry phones
    if (hasInterface && {!(unitIsUAV _vehicle)}) then {
        [_vehicle] call FUNC(infantryPhoneAction);
    };
};
