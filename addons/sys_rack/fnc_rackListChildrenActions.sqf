#include "script_component.hpp"
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

params ["_target"];

private _actions = [];

private _racks = [_target, acre_player] call FUNC(getAccessibleVehicleRacks);
{
    _racks pushBackUnique _x;
} forEach ([_target, acre_player] call FUNC(getHearableVehicleRacks));
private _radios = (_racks apply {[_x] call FUNC(getMountedRadio)}) select {_x != ""};

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

private _action = [QGVAR(useAllRacks), localize LSTRING(useAllRacks), "", {
    params ["_vehicle", "_unit", "_radios"];
    {
        [_vehicle, _unit, _x] call FUNC(startUsingMountedRadio);
    } forEach (_radios select {!(_x in ACRE_ACCESSIBLE_RACK_RADIOS || {_x in ACRE_HEARABLE_RACK_RADIOS})});
}, {
    ({!(_x in ACRE_ACCESSIBLE_RACK_RADIOS || {_x in ACRE_HEARABLE_RACK_RADIOS})} count _this#2) > 0
}, {}, _radios] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

private _action = [QGVAR(stopUsingAllRacks), localize LSTRING(stopUsingAllRacks), "", {
    params ["_vehicle", "_unit", "_radios"];
    {
        [_vehicle, _unit, _x] call FUNC(stopUsingMountedRadio);
    } forEach (_radios select {_x in ACRE_ACCESSIBLE_RACK_RADIOS || {_x in ACRE_HEARABLE_RACK_RADIOS}});
}, {
    ({_x in ACRE_ACCESSIBLE_RACK_RADIOS || {_x in ACRE_HEARABLE_RACK_RADIOS}} count _this#2) > 0
}, {}, _radios] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

_actions
