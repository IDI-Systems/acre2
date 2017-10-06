/*
 * Author: ACRE2Team
 * Initialises all intercoms in a vehicle, as well as the infantry phone.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Interaction Available <BOOL>
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_initVehicleIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _classname = typeOf _vehicle;

private _intercoms = configFile >> "CfgVehicles" >> _classname >> "AcreIntercoms";

if (count _intercoms != 0) then {
    [_vehicle] call FUNC(configIntercom);
    [_vehicle] call FUNC(configIntercomStations);

    if (hasInterface && (isClass (configFile >> "CfgPatches" >> "ace_interact_menu"))) then {
        [_vehicle] call FUNC(intercomAction);
    };

    // Exit if object has no infantry phone
    if (getNumber (configFile >> "CfgVehicles" >> _classname >> "acre_hasInfantryPhone") == 1) then {
        [_vehicle] call FUNC(configInfantryPhone);
        // UAV units should not have infantry phones
        if (hasInterface && !(unitIsUAV _vehicle)) then {
            [_vehicle] call FUNC(infantryPhoneAction);
        };
    };
};
