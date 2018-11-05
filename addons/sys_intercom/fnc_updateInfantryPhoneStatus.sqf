#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the status of the infantry phone of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit using the infantry phone <OBJECT>
 * 2: Type of action <NUMBER>
 * 3: Intercom network <NUMBER>
 * 4: Unit giving the infantry phone <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1, 0] call acre_sys_intercom_fnc_updateInfantryPhoneStatus
 * [cursorTarget, infantryUnit, 1, 0, player] call acre_sys_intercom_fnc_updateInfantryPhoneStatus
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_action", "_intercomNetwork", ["_givingUnit", objNull, [objNull]]];

private _intercomName = ((_vehicle getVariable [QGVAR(intercomNames), []]) select _intercomNetwork) select 1;
private _intercomText = format ["( %1 )", _intercomName];

switch (_action) do {
    case 0: {
        // Stop using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), nil, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), nil, true];

        ACRE_PLAYER_INTERCOM = [];
        [format [localize LSTRING(infantryPhoneDisconnected), _intercomText], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;
    };
    case 1: {
        // Start using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];

        [format [localize LSTRING(infantryPhoneConnected), _intercomText], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        GVAR(intercomPFH) = [DFUNC(intercomPFH), 1.1, [acre_player, _vehicle]] call CBA_fnc_addPerFrameHandler;
    };
    case 2: {
        // Give the intercom to another unit
        _givingUnit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
        [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;

        [QGVAR(giveInfantryPhone), ["_vehicle", "_unit", 1, _intercomNetwork], _unit] call CBA_fnc_targetEvent;
        [format [localize LSTRING(infantryPhoneReceived), _intercomText], ICON_RADIO_CALL, nil, _unit] call EFUNC(sys_core,displayNotification);
    };
    case 3: {
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];
    };
};

// Hook for third party mods with actions when picking returning infantry phone
private _event = _vehicle getVariable [QGVAR(eventInfantryPhone), ""];
if (_event != "") then {
    _event = missionNamespace getVariable [_event, {}];
    if (_event isEqualType {} && !(_event isEqualTo {})) then {
        [_vehicle, _unit, _action] call _event;
    };
};
