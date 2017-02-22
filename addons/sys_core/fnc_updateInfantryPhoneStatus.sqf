/*
 * Author: ACRE2Team
 * Updates the status of the infantry phone of a vehicle
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit using the infantry phone <OBJECT>
 * 2: Type of action <NUMBER>
 * 3: Unit giving the infantry phone <OBJECT><OPTIONAL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1] call acre_sys_core_updateInfantryPhoneStatus
 * [cursorTarget, infantryUnit, 1, player] call acre_sys_core_updateInfantryPhoneStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unitInfantryPhone", "_action", "_givingUnit"];

switch (_action) do {
    case 0: {
        // Stop using the intercom externally
        _vehicle setVariable ["unitInfantryPhone", nil, true];
        _unitInfantryPhone setVariable ["vehicleInfantryPhone", nil, true];
        systemChat format ["Stop using infantry phone of vehicle %1", _vehicle];
    };

    case 1: {
        _vehicle setVariable ["unitInfantryPhone", _unitInfantryPhone, true];
        _unitInfantryPhone setVariable ["vehicleInfantryPhone", _vehicle, true];
        systemChat format ["Start using infantry phone of vehicle %1", _vehicle];
    };

    case 2: {
        // Give the intercom to another unit
        _vehicle setVariable ["unitInfantryPhone", _unitInfantryPhone, true];
        _unitInfantryPhone setVariable ["vehicleInfantryPhone", _vehicle, true];
        _givingUnit setVariable ["vehicleInfantryPhone", nil, true];
        systemChat format ["Giving infantry phone of vehicle %1 to %2", _vehicle, _unitInfantryPhone];
    };
};
