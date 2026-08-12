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

private _connectedPlayer = [_connectedRadio] call EFUNC(sys_radio,getRadioObject);

// Temporarily disconnect the GSA from the radio
if (_connectedRadio != "") then {
    [_connectedPlayer, _gsa] call FUNC(disconnect);
};

// Delete the antenna
private _pos = getPosASL _gsa;
private _vectorDir = vectorDir _gsa;
private _vectorUp = vectorUp _gsa;
deleteVehicle _gsa;

// Create the new vehicle
if (_mountMast) then {
    _gsa = "vhf30108Item" createVehicle [0, 0, 0];

    _player removeItem "ACRE_VHF30108MAST";
} else {
    _gsa = "vhf30108spike" createVehicle [0, 0, 0];
    _pos set [2, (_pos select 2) + 0.168]; // The spike will sink into the ground if not
    [_player, "ACRE_VHF30108MAST", true] call CBA_fnc_addItem;
};
_gsa setPosASL _pos;
_gsa setVectorDirAndUp [_vectorDir, _vectorUp];

// Reconnect the GSA to the radio
if (_connectedRadio != "") then {
    [QGVAR(connectGsa), [_gsa, _connectedRadio, _connectedPlayer]] call CBA_fnc_serverEvent;
};
