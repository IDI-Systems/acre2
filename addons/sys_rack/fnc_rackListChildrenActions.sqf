/*
 * Author: ACRE2Team
 * Generates a list of actions for a vehicle rack.
 *
 * Arguments:
 * 0: Vehicle with racks <OBJECT>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [vehicle acre_player] call acre_sys_rack_fnc_rackListChildrenActions
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

{
    // _x is rack classname
    private _config = configFile >> "CfgVehicles" >> _x;
    private _name = [_x, "getState", "name"] call EFUNC(sys_data,dataEvent);
    private _displayName = format ["%1 (%2)", _name, getText (_config >> "displayName")];

    private _action = [
        _x,
        _displayName,
        QPATHTOEF(ace_interact,data\icons\rack.paa),
        {true},
        {true},
        {_this call FUNC(rackChildrenActions);},
        [_x]
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _racks;

_actions
