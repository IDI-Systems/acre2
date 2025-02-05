#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for connecting a ground spike antenna.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: unique rack ID <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [vehicle acre_player] call acre_sys_gsa_fnc_connectChildrenActions
 *
 * Public: No
 */

params ["_unit", "_target"];

private _radioList = [] call EFUNC(sys_data,getPlayerRadioList);
private _actions = [];

{
    private _owner = "";
    if (_x in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        _owner = format [" (%1)", name ([_x] call EFUNC(sys_external,getExternalRadioOwner))];
    };

    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = configFile >> "CfgWeapons" >> _baseRadio;

    private _displayName = [_x] call EFUNC(sys_core,getDescriptiveName);
    private _picture = getText (_item >> "picture");

    private _action = [
        _x,
        _displayName,
        _picture,
        {
            params ["_gsa", "", "_params"];
            _params params ["_radioId"];

            [_gsa, _radioId] call FUNC(connect);
        },
        {
            params ["_gsa", "", "_params"];
            _params params ["_radioId"];

            [_gsa, _radioId] call FUNC(isRadioCompatible);
        },
        {},
        [_x]
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _radioList;

_actions
