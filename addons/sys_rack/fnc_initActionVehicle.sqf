#include "script_component.hpp"
/*
 * Author: ACRE2 Team
 * Initializes vehicle adds the ACE interact options on vehicles
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle] call acre_sys_rack_fnc_initActionVehicle
 *
 * Public: No
 */

params ["_vehicle"];

private _type = typeOf _vehicle;

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses)) exitWith {};
// set class as initialized
GVAR(initializedVehicleClasses) pushBack _type;

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interaction")) exitWith {}; // No ACE exit

private _condition = {true};
private _statement = {}; // With no statement the action will only show if it has children
private _text = localize LSTRING(Racks);
private _icon = "\idi\acre\addons\ace_interact\data\icons\rack3.paa";
private _children = {_this call FUNC(rackListChildrenActions);};

// Passenger action
private _action = [QGVAR(racks), _text, _icon, _statement, _condition, _children, [], {[0,0,0]},2,[false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

// External action
private _action = [QGVAR(racks), _text, _icon, _statement, _condition, _children, [], {[0,0,0]},2,[false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
