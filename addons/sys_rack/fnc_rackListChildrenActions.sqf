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

private _accessibleRacks = [_target, acre_player] call FUNC(getAccessibleVehicleRacks);
private _hearableRacks = [_target, acre_player] call FUNC(getHearableVehicleRacks);
private _racks = _accessibleRacks + (_hearableRacks - (_accessibleRacks arrayIntersect _hearableRacks));
private _radios = (_racks apply {[_x] call FUNC(getMountedRadio)}) select {_x != ""};
private _usableRadios = _radios select {!([_x, acre_player] call FUNC(isRadioHearable))};
private _usableInaccessibleRadios = _usableRadios select {!(_x in ACRE_ACCESSIBLE_RACK_RADIOS)};
private _usableAccessibleRadios = _usableRadios select {_x in ACRE_ACCESSIBLE_RACK_RADIOS};
TRACE_7("rack actions",_accessibleRacks,_hearableRacks,_racks,_radios,_usableRadios,_usableInaccessibleRadios,_usableAccessibleRadios);

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
} forEach _accessibleRacks;

if !(_usableInaccessibleRadios isEqualTo []) then {
    private _action = [
        QGVAR(useAllRacks),
        localize LSTRING(useAllRacks),
        "",
        {
            params ["_vehicle", "_unit", "_radios"];
            {
                [_vehicle, _unit, _x] call FUNC(startUsingMountedRadio);
            } forEach _radios;
        },
        {true},
        {},
        _usableInaccessibleRadios
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if !(_usableAccessibleRadios isEqualTo []) then {
    _action = [
        QGVAR(stopUsingAllRacks),
        localize LSTRING(stopUsingAllRacks),
        "",
        {
            params ["_vehicle", "_unit", "_radios"];
            {
                [_vehicle, _unit, _x] call FUNC(stopUsingMountedRadio);
            } forEach _radios;
        },
        {true},
        {},
        _usableAccessibleRadios
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
