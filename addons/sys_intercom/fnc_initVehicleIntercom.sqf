#include "script_component.hpp"
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

params ["_vehicle"];

private _classname = typeOf _vehicle;

private _intercoms = configProperties [configFile >> "CfgVehicles" >> _classname >> "AcreIntercoms", "isClass _x", true];

if !(_intercoms isEqualTo []) then {
    [_vehicle, _intercoms] call FUNC(configIntercom);

    if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_interact_menu")}) then {
        [_vehicle] call FUNC(intercomAction);
    };

    // Exit if object has no infantry phone
    if (getNumber (configFile >> "CfgVehicles" >> _classname >> "acre_hasInfantryPhone") == 1) then {
        [_vehicle] call FUNC(configInfantryPhone);
        // UAV units should not have infantry phones
        if (hasInterface && {!(unitIsUAV _vehicle)}) then {
            [_vehicle] call FUNC(infantryPhoneAction);
        };
    };
};
