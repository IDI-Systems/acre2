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

//private _classname = typeOf _gsa;
//private _componentName = configFile >> "CfgVehicles" >> _classname >> "AcreComponents";
private _componentName = "ACRE_643CM_VHF_TNC";
systemChat format ["_radioId %1 component %2", _radioId, _componentName];
// Force attach the ground spike antenna
[_radioId, 0, _componentName, [], true] call EFUNC(sys_components,attachSimpleComponent);
