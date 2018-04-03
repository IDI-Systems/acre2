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
#include "script_component.hpp"

params ["_gsa"];

systemChat format ["gsa %1", _gsa];
if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interaction")) exitWith {}; // No ACE exit.

private _type = typeOf _gsa;

// Exit if class already initialized
if (_type in GVAR(initializedAntennas)) exitWith {};
GVAR(initializedAntennas) pushBack _type;

// Pickup action
private _pickUp = [
    QGVAR(pickUp),
    "test",
    "",
    {systemChat format ["pickup"];},
    {true},
    {},
    [],
    [0, 0, 0],
    10,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;

[_type, 1, ["ACE_MainActions"], _pickUp] call ace_interact_menu_fnc_addActionToClass;
