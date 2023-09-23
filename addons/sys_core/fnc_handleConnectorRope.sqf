#include "script_component.hpp"
/*
 * Author: mrschick
 * Handles Phys-X Ropes to represent "connector wires" for infantry phone, GSA, radio sharing, etc.
 *
 * Arguments:
 * 0: State: true to create rope, false to remove <BOOLEAN>
 * 1: Vehicle or object the rope starts from <OBJECT> (default: objNull)
 * 2: Unit the rope should be attached to <OBJECT> (default: objNull)
 * 3: Relative position offset for where the rope starts from <POSITION> (default: [0,0,0])
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

params ["_state", ["_fromObject", objNull], ["_toObject", objNull], ["_fromPoint", [0, 0, 0]]];

if (_state) then {
    // Create rope
    GVAR(connectorRope) = ropeCreate [_fromObject, _fromPoint, 1.5];
    GVAR(connectorRopeHelper) = "Land_Can_V2_F" createVehicle position _toObject;
    [GVAR(connectorRopeHelper), [0, 0, 0]] ropeAttachTo GVAR(connectorRope);
    GVAR(connectorRopeHelper) attachTo [_toObject, [-0.1, 0.1, 0.25], "Pelvis"];
    hideObjectGlobal GVAR(connectorRopeHelper);
    systemChat "created rope";
} else {
    // Destroy rope
    deleteVehicle GVAR(connectorRopeHelper);
    GVAR(connectorRopeHelper) = objNull;
    ropeDestroy GVAR(connectorRope);
    GVAR(connectorRope) = objNull;
    systemChat "deleted rope";
};
