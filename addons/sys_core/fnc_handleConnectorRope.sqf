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
    switch (_type) do {
        case 0: { // Connect rope to Infantry Phone
            // Adjust Rope start position to not interfere with interaction
            //_fromPoint set [2, (_fromPoint select 2) - 0.3]; // Lower Z coordinate by 30cm ---------------------- CHECK IF NEEDED

            // Create Rope
            GVAR(connectorRope) = ropeCreate [_fromObject, _fromPoint, 3, nil, nil, QGVAR(connectorWire)];

            // Create helper object on player pelvis
            GVAR(connectorRopeHelpers) set [0, "Land_Can_V2_F" createVehicle position _toObject];
            [GVAR(connectorRopeHelpers) select 0, [0, 0, 0]] ropeAttachTo GVAR(connectorRope);
            (GVAR(connectorRopeHelpers) select 0) attachTo [_toObject, [-0.1, 0.1, 0.25], "Pelvis"];
            hideObjectGlobal (GVAR(connectorRopeHelpers) select 0);
            systemChat "created rope";
        };
        case 1: { // Connect rope to Ground Spike Antenna
            // Adjust Rope start position to not interfere with interaction
            /*if (typeOf _fromObject == "vhf30108spike") then {
                _fromPoint set [1, (_fromPoint select 1) - 0.2]; // Shift Y coordinate by 20cm ---------------------- CHECK IF NEEDED
            };*/

            // Create helper object on GSA
            GVAR(connectorRopeHelpers) set [0, "PaperCar" createVehicle position _fromObject];
            (GVAR(connectorRopeHelpers) select 0) disableCollisionWith _fromObject;
            (GVAR(connectorRopeHelpers) select 0) setPos (position _fromObject);
            hideObject (GVAR(connectorRopeHelpers) select 0);

            // Create helper object on player pelvis
            GVAR(connectorRopeHelpers) set [1, "Land_Can_V2_F" createVehicle position player];
            (GVAR(connectorRopeHelpers) select 1) attachTo [player, [-0.1, 0.1, 0.15], "Pelvis"];
            hideObject (GVAR(connectorRopeHelpers) select 1);

            // Create Rope between helper objects
            GVAR(connectorRope) = ropeCreate [GVAR(connectorRopeHelpers) select 0, _fromPoint, 5, nil, nil, QGVAR(connectorWire)];
            [(GVAR(connectorRopeHelpers) select 1), [0, 0, 0]] ropeAttachTo GVAR(connectorRope);
            systemChat "created rope";
        };
        case 2: { // Connect rope to shared backpack radio owner
            // Create helper object on radio owner
            GVAR(connectorRopeHelpers) set [0, "PaperCar" createVehicle position _fromObject];
            (GVAR(connectorRopeHelpers) select 0) attachTo [_fromObject, [-0.1, 0.1, 0.15], "Pelvis"];
            hideObject (GVAR(connectorRopeHelpers) select 0);

            // Create helper object on player pelvis
            GVAR(connectorRopeHelpers) set [1, "Land_Can_V2_F" createVehicle position player];
            (GVAR(connectorRopeHelpers) select 1) attachTo [player, [-0.1, 0.1, 0.15], "Pelvis"];
            hideObject (GVAR(connectorRopeHelpers) select 1);

            // Create Rope between helper objects
            GVAR(connectorRope) = ropeCreate [GVAR(connectorRopeHelpers) select 0, _fromPoint, 3, nil, nil, QGVAR(connectorWire)];
            [GVAR(connectorRopeHelpers) select 1, [0, 0, 0]] ropeAttachTo GVAR(connectorRope);
            systemChat "created rope";
        };
    };
} else {
    // Destroy rope
    ropeDestroy GVAR(connectorRope);
    GVAR(connectorRope) = objNull;
    { deleteVehicle _x } forEach GVAR(connectorRopeHelpers);
    GVAR(connectorRopeHelpers) = [objNull, objNull];
    systemChat "deleted rope";
};
