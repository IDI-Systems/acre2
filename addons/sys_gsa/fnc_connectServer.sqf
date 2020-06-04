#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Connects the ground spike antenna to a compatible radio. Server Event.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 * 1: Unique Radio ID <STRING>
 * 2: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [gsa, "acre_prc152_id_1", player] call acre_sys_gsa_fnc_connectServer
 *
 * Public: No
 */

params ["_gsa", "_radioId", "_player"];

if (_radioId == "") exitWith { ERROR_3("connectServer - bad radioID %1:%2:%3",_gsa,_radioId,_player); };

private _classname = typeOf _gsa;
private _componentName = getText (configFile >> "CfgVehicles" >> _classname >> "AcreComponents" >> "componentName");

// Check if the antenna was connected somewhere else
private _connectedGsa = [_radioId, "getState", "externalAntennaConnected"] call EFUNC(sys_data,dataEvent);

// Do nothing if the antenna is already connected
if (_connectedGsa select 0) exitWith {
    [QGVAR(notifyPlayer), [localize LSTRING(alreadyConnected)], _player] call CBA_fnc_targetEvent;
};

// Force attach the ground spike antenna
[_radioId, 0, _componentName, HASH_CREATE, true] call EFUNC(sys_components,attachSimpleComponent);

_gsa setVariable [QGVAR(connectedRadio), _radioId, true];
[_radioId, "setState", ["externalAntennaConnected", [true, _gsa]]] call EFUNC(sys_data,dataEvent);

[QGVAR(notifyPlayer), [localize LSTRING(connected)], _player] call CBA_fnc_targetEvent;

// Support for having several radios connected to GSA
private _pfh = [DFUNC(externalAntennaPFH), 1.0, [_gsa, _radioId]] call CBA_fnc_addPerFrameHandler;
[GVAR(gsaPFH), _radioId, _pfh] call CBA_fnc_hashSet;
