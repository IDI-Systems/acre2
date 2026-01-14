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
 * 5: Relative position of the infantry phone interaction on the vehicle <POSITION> (default: [0, 0, 0])
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

params ["_vehicle", "_unit", "_action", "_intercomNetwork", ["_givingUnit", objNull, [objNull]], ["_position", [0, 0, 0]]];

private _intercomName = ((_vehicle getVariable [QGVAR(intercomNames), []]) select _intercomNetwork) select 1;
private _intercomText = format ["( %1 )", _intercomName];

switch (_action) do {
    case 0: {
        TRACE_3("Disconnect infantry phone",_vehicle,_unit,_intercomNetwork);
        // Stop using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), nil, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), nil, true];

        // Destroy connector rope
        [QEGVAR(sys_core,handleConnectorRopeEvent), [false]] call CBA_fnc_localEvent;

        ACRE_PLAYER_INTERCOM = [];
        [[ICON_RADIO_CALL], [format [localize LSTRING(infantryPhoneDisconnected), _intercomText]], true] call CBA_fnc_notify;
        [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;
    };
    case 1: {
        TRACE_3("Connect infantry phone",_vehicle,_unit,_intercomNetwork);
        // Start using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];

        // Create connector rope
        [QEGVAR(sys_core,handleConnectorRopeEvent), [true, 0, _vehicle, _unit, _position]] call CBA_fnc_localEvent;

        [[ICON_RADIO_CALL], [format [localize LSTRING(infantryPhoneConnected), _intercomText]], true] call CBA_fnc_notify;
        GVAR(intercomPFH) = [DFUNC(intercomPFH), 1.1, [acre_player, _vehicle]] call CBA_fnc_addPerFrameHandler;
    };
    case 2: {
        TRACE_4("Give infantry phone to another unit",_vehicle,_unit,_intercomNetwork,_givingUnit);
        // Give the intercom to another unit
        _givingUnit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
        [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;

        // Destroy connector rope
        [QEGVAR(sys_core,handleConnectorRopeEvent), [false]] call CBA_fnc_localEvent;

        private _message = format [localize LSTRING(infantryPhoneReceived), _intercomText];
        [QGVAR(giveInfantryPhone), [_vehicle, _unit, 1, _message, _intercomNetwork, _position], _unit] call CBA_fnc_targetEvent;
    };
    case 3: {
        TRACE_3("Update infantry phone vars",_vehicle,_unit,_intercomNetwork);
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];
    };
};

// Hook for third party mods with actions when picking returning infantry phone
private _event = _vehicle getVariable [QGVAR(eventInfantryPhone), ""];
if (_event != "") then {
    _event = missionNamespace getVariable [_event, {}];
    if (_event isEqualType {} && (_event isNotEqualTo {})) then {
        [_vehicle, _unit, _action] call _event;
    };
};
