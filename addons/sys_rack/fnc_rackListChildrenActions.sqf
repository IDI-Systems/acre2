/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _actions = [];

private _racks = [_target, acre_player] call FUNC(getAccessibleVehicleRacks);

{
    _racks pushBackUnique _x;
} forEach ([_target, acre_player] call FUNC(getHearableVehicleRacks));

reverse _racks;

{
    private _rackClassName = _x;
    private _config = ConfigFile >> "CfgVehicles" >> _rackClassName;
    private _displayName = getText (_config >> "displayName");

    private _name = [_rackClassName, "getState", "name"] call EFUNC(sys_data,dataEvent);
    _displayName = format ["%1 (%2)", _name, _displayName];

    private _action = [_rackClassName, _displayName, "\idi\acre\addons\ace_interact\data\icons\rack.paa", {true /*Statement/Action */}, {true}, {_this call FUNC(rackChildrenActions);}, [_rackClassName]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _racks;

_actions;
