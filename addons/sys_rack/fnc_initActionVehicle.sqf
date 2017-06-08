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
 * [vehicle] call acre_sys_ace_interact_fnc_initVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _type = typeOf _vehicle;

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses)) exitWith {};
// set class as initialized
GVAR(initializedVehicleClasses) pushBack _type;

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_interaction")) exitWith {}; // No ACE exit.

////{alive _target} &&
private _condition = {
    //true
    //{[_player, _target, ["isNotInside"]] call ace_common_fnc_canInteractWith}
     //{[_player, _target, ["isNotSwimming"]] call EFUNC(common,canInteractWith)}
     params ["_target","_unit"];
     private _accessibleRacks = [_target, _unit] call FUNC(getAccessibleVehicleRacks);
     private _hearableRacks = [_target, _unit] call FUNC(getHearableVehicleRacks);
     (count _accessibleRacks > 0 || count _hearableRacks > 0)
};
private _statement = {true};
private _text = localize LSTRING(Racks);
private _icon = "\idi\acre\addons\ace_interact\data\icons\rack3.paa"; // "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"; // ""

private _children = {_this call FUNC(rackListChildrenActions);};

// Passenger action
private _action = [QGVAR(racks), _text, _icon, _statement, _condition, _children, [], {[0,0,0]},2,[false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

// External action.
private _action = [QGVAR(racks), _text, _icon, _statement, _condition, _children, [], {[0,0,0]},2,[false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
