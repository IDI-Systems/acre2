/*
 * Author: ACRE2Team
 * Connects the ground spike antenna to a compatible radio.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_connect
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_gsa", "_radioId"];

private _classname = typeOf _gsa;
private _componentName = getText (configFile >> "CfgVehicles" >> _classname >> "AcreComponents" >> "componentName");

// Check if the antenna was connected somewhere else
private _connectedGsa = [_radioId, "getState", "externalAntennaConnected"] call EFUNC(sys_data,dataEvent);

if (_connectedGsa select 0) then {
    // Disconnect from antenna
    [acre_player, _connectedGsa select 1] call FUNC(disconnect);
};

// Force attach the ground spike antenna
[_radioId, 0, _componentName, [], true] call EFUNC(sys_components,attachSimpleComponent);

_gsa setVariable [QGVAR(connectedRadio), _radioId, true];
[_radioId, "setState", ["externalAntennaConnected", [true, _gsa]]] call EFUNC(sys_data,dataEvent);

[localize LSTRING(connected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);

systemChat format ["conn. to %1", _gsa getVariable [QGVAR(connectedRadio), ""]];
