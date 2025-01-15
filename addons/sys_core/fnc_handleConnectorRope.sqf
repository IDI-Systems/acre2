#include "script_component.hpp"
/*
 * Author: mrschick
 * Handles PhysX Ropes to represent "connector wires" for infantry phone, GSA, radio sharing, etc.
 *
 * Arguments:
 * 0: State: true to create rope, false to remove <BOOLEAN>
 * 1: Type of object to connect to: 0 = Infantry Phone, 1 = GSA, 2 = Shared radio <NUMBER> (default: 0)
 * 2: Vehicle or object the rope starts from <OBJECT> (default: objNull)
 * 3: Unit the rope should be attached to <OBJECT> (default: objNull)
 * 4: Relative position offset for where the rope starts from <POSITION> (default: [0,0,0])
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, _vehicle, _player, _infantryPhonePosition] call acre_sys_intercom_fnc_handleConnectorRope
 * [false] call acre_sys_intercom_fnc_handleConnectorRope
 *
 * Public: No
 */

params ["_state", ["_type", 0], ["_fromObject", objNull], ["_toObject", objNull], ["_fromPoint", [0, 0, 0]]];

if (!EGVAR(sys_gestures,showConnectorRopes)) exitWith {};

if (_state) then {
    // Destroy any previous connector rope and helpers
    if (!isNull GVAR(connectorRope) || {GVAR(connectorRopeHelpers) isNotEqualTo [objNull, objNull]}) then {
        [false] call FUNC(handleConnectorRope);
    };

    private _connectorRopeHelpers = [];
    private _connectorRope = objNull;

    switch (_type) do {
        case 0: { // Connect rope to Infantry Phone
            // If _fromPoint could not be provided by the intercom passing action, fetch it again from config
            if (_fromPoint isEqualTo [-1]) then {
                private _positionConfig = configFile >> "CfgVehicles" >> typeOf _fromObject >> "acre_infantryPhonePosition";
                if (isText _positionConfig) then {
                    _fromPoint = _fromObject selectionPosition (getText _positionConfig); // Convert to coordinates for sys_core intercomPFH checks
                };
                if (isArray _positionConfig) then {
                    _fromPoint = getArray _positionConfig;
                };
            };

            // Create Rope
            _connectorRope = ropeCreate [_fromObject, _fromPoint, 3, nil, nil, QGVAR(connectorWire)];

            // Create helper object on player pelvis
            _connectorRopeHelpers set [0, ROPE_HELPER createVehicle (getPosATL _toObject)];
            (_connectorRopeHelpers select 0) ropeAttachTo _connectorRope;
            (_connectorRopeHelpers select 0) attachTo [_toObject, [-0.1, 0.1, 0.25], "Pelvis"];
            (_connectorRopeHelpers select 0) allowDamage false;

            // Hide Helper Object
            [QGVAR(hideConnectorRopeHelpers), [_connectorRopeHelpers]] call CBA_fnc_serverEvent;
        };
        case 1: { // Connect rope to Ground Spike Antenna
            // Create helper object on GSA
            _connectorRopeHelpers set [0, ROPE_HELPER createVehicle (getPosATL _fromObject)];
            (_connectorRopeHelpers select 0) disableCollisionWith _fromObject;
            (_connectorRopeHelpers select 0) setPosATL (getPosATL _fromObject);
            (_connectorRopeHelpers select 0) allowDamage false;

            // Create helper object on player pelvis
            _connectorRopeHelpers set [1, ROPE_HELPER createVehicle (getPosATL _toObject)];
            (_connectorRopeHelpers select 1) attachTo [_toObject, [-0.1, 0.1, 0.15], "Pelvis"];
            (_connectorRopeHelpers select 1) allowDamage false;

            // Hide Helper Objects
            [QGVAR(hideConnectorRopeHelpers), [_connectorRopeHelpers]] call CBA_fnc_serverEvent;

            // Create Rope between helper objects
            _connectorRope = ropeCreate [_connectorRopeHelpers select 0, _fromPoint, 5, nil, nil, QGVAR(connectorWire)];
            (_connectorRopeHelpers select 1) ropeAttachTo _connectorRope;
        };
    };

    GVAR(connectorRope) = _connectorRope;
    GVAR(connectorRopeHelpers) = _connectorRopeHelpers;
} else {
    // Destroy rope
    ropeDestroy GVAR(connectorRope);
    GVAR(connectorRope) = objNull;
    { deleteVehicle _x } forEach GVAR(connectorRopeHelpers);
    GVAR(connectorRopeHelpers) = [objNull, objNull];
};
