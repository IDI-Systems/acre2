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

private _helper = QGVAR(connectorHelper);

if (_state) then {
    private _connectorRopeHelpers = [];
    private _connectorRope = "";

    switch (_type) do {
        case 0: { // Connect rope to Infantry Phone
            // Create Rope
            _connectorRope = ropeCreate [_fromObject, _fromPoint, 3, nil, nil, QGVAR(connectorWire)];

            // Create helper object on player pelvis
            _connectorRopeHelpers set [0, _helper createVehicle position _toObject];
            [_connectorRopeHelpers select 0, [0, 0, 0]] ropeAttachTo _connectorRope;
            (_connectorRopeHelpers select 0) attachTo [_toObject, [-0.1, 0.1, 0.25], "Pelvis"];
            [(_connectorRopeHelpers select 0), true] remoteExec ["hideObjectGlobal", 2];
            (_connectorRopeHelpers select 0) allowDamage false;
        };
        case 1: { // Connect rope to Ground Spike Antenna
            // Create helper object on GSA
            _connectorRopeHelpers set [0, _helper createVehicle position _fromObject];
            (_connectorRopeHelpers select 0) disableCollisionWith _fromObject;
            (_connectorRopeHelpers select 0) setPos (position _fromObject);
            [(_connectorRopeHelpers select 0), true] remoteExec ["hideObjectGlobal", 2];
            (_connectorRopeHelpers select 0) allowDamage false;

            // Create helper object on player pelvis
            _connectorRopeHelpers set [1, _helper createVehicle position player];
            (_connectorRopeHelpers select 1) attachTo [player, [-0.1, 0.1, 0.15], "Pelvis"];
            [(_connectorRopeHelpers select 1), true] remoteExec ["hideObjectGlobal", 2];
            (_connectorRopeHelpers select 1) allowDamage false;

            // Create Rope between helper objects
            _connectorRope = ropeCreate [_connectorRopeHelpers select 0, _fromPoint, 5, nil, nil, QGVAR(connectorWire)];
            [(_connectorRopeHelpers select 1), [0, 0, 0]] ropeAttachTo _connectorRope;
        };
        case 2: { // Connect rope to shared backpack radio owner
            // Create helper object on radio owner
            _connectorRopeHelpers set [0, _helper createVehicle position _fromObject];
            (_connectorRopeHelpers select 0) attachTo [_fromObject, [-0.1, 0.1, 0.15], "Pelvis"];
            [(_connectorRopeHelpers select 0), true] remoteExec ["hideObjectGlobal", 2];
            (_connectorRopeHelpers select 0) allowDamage false;

            // Create helper object on player pelvis
            _connectorRopeHelpers set [1, _helper createVehicle position player];
            (_connectorRopeHelpers select 1) attachTo [player, [-0.1, 0.1, 0.15], "Pelvis"];
            [(_connectorRopeHelpers select 1), true] remoteExec ["hideObjectGlobal", 2];
            (_connectorRopeHelpers select 1) allowDamage false;

            // Create Rope between helper objects
            _connectorRope = ropeCreate [_connectorRopeHelpers select 0, _fromPoint, 3, nil, nil, QGVAR(connectorWire)];
            [_connectorRopeHelpers select 1, [0, 0, 0]] ropeAttachTo _connectorRope;
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
