#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds an action for interacting with the ground spike antenna.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_gsa_fnc_initGsa
 *
 * Public: No
 */

params ["_player", "_gsa", "_mountMast", ["_connectedRadio", ""]];

if (_connectedRadio isEqualTo "") then {
    _connectedRadio = _gsa getVariable [QGVAR(connectedRadio), ""];
};

// Temporarily disconnect the GSA from the radio.
if (_connectedRadio != "") then {
    [_player, _gsa, _connectedRadio] call FUNC(disconnect);
};

// Delete the antenna
private _pos = getPosASL _gsa;
deleteVehicle _gsa;

// Create the new vehicle
if (_mountMast) then {
    _gsa = "vhf30108Item" createVehicle (_pos vectorAdd [0, 0, MAST_Z_OFFSET]);

    _player removeItem "acre2_vhf30108mast";
} else {
    _gsa = "vhf30108spike" createVehicle _pos;

    if (_player canAdd "acre2_vhf30108mast") then {
        _player addItem "acre2_vhf30108mast";
    } else {
        // Create the mast as an item on the floor
    };
};

// Reconnect the GSA to the radio
if (_connectedRadio != "") then {
    [_gsa, _connectedRadio] call FUNC(connect);
};
