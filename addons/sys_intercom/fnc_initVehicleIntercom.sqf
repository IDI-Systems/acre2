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
    // Make the clients initialise the intercom to avoid JIP issues overriding actual configuration
    if (isServer) then {
        [QGVAR(initIntercom), [_vehicle, _intercoms]] call CBA_fnc_globalEvent;
    };

    if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_interact_menu")}) then {
        [_vehicle] call FUNC(intercomAction);
    };

    // Exit if object has no infantry phone
    if (getNumber (configFile >> "CfgVehicles" >> _classname >> "acre_hasInfantryPhone") == 1) then {
        // Infantry phone can be initialised on clients without fear of overriding something.

        [_vehicle] call FUNC(configInfantryPhone);
        // UAV units should not have infantry phones
        if (hasInterface && {!(unitIsUAV _vehicle)}) then {
            [_vehicle] call FUNC(infantryPhoneAction);
        };
    };
};
