#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using a radio in the player's inventory or externally used radios
 *
 * Arguments:
 * 0: Vehicle with racks <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: rack class name <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [vehicle acre_player, "", ["ACRE_VRC103_ID_1"]] call acre_sys_rack_fnc_generateMountableRadioActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_rackClassName"];

private _actions = [];

private _radioList = [] call EFUNC(api,getCurrentRadioList);
_radioList = [_rackClassName, _radioList] call FUNC(getMountableRadios);

{
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName");
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize ELSTRING(ace_interact,channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");
    //private _isActive = _x isEqualTo _currentRadio;

    private _action = [_x, _displayName, _picture, {
        params ["","_unit","_params"];
        _params params ["_rackClassName","_radioId"];
        [_rackClassName, _radioId, _unit] call FUNC(mountRadio);
    }, {true}, {}, [_rackClassName, _x]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _radioList;


_actions;
