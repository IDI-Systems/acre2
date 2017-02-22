/*
 * Author: ACRE2Team
 * Updates the status of the infantry phone of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit using the infantry phone <OBJECT>
 * 2: Type of action <NUMBER>
 * 3: Unit giving the infantry phone <OBJECT> (default: objNull)
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

params ["_vehicle", "_unit", "_action", ["_givingUnit", objNull, [objNull]]];

switch (_action) do {
    case 0: {
        // Stop using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), nil, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
        hintSilent "Infantry Phone disconnected";
    };
    case 1: {
        _vehicle setVariable [QGVAR(unitInfantryPhone), _unit, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), _vehicle, true];
    };
    case 2: {
        // Give the intercom to another unit
        _vehicle setVariable [QGVAR(unitInfantryPhone), _unit, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), _vehicle, true];
        _givingUnit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
    };
};
