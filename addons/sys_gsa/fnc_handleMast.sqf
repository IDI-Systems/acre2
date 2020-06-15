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
 * [cursorTarget] call acre_sys_gsa_fnc_handleMast
 *
 * Public: No
 */

params ["_player", "_gsa", "_mountMast", ["_connectedRadio", ""]];

if (_connectedRadio isEqualTo "") then {
    _connectedRadio = _gsa getVariable [QGVAR(connectedRadio), ""];
};

// Temporarily disconnect the GSA from the radio
if (_connectedRadio != "") then {
    [_player, _gsa] call FUNC(disconnect);
};

// Delete the antenna
private _pos = getPosASL _gsa;
deleteVehicle _gsa;

// Create the new vehicle
if (_mountMast) then {
    _gsa = "vhf30108Item" createVehicle _pos;

    _player removeItem "ACRE_VHF30108MAST";
} else {
    _gsa = "vhf30108spike" createVehicle _pos;

    [_player, "ACRE_VHF30108MAST", true] call CBA_fnc_addItem;
};

// Reconnect the GSA to the radio
if (_connectedRadio != "") then {
    [_gsa, _connectedRadio] call FUNC(connect);
};
