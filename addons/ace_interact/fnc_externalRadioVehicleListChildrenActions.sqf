/*
 * Author: ACRE2Team
 * Generates a list of actions for radios inside a vehicle
 *
 * Arguments:
 * 0: Vehicle with ACRE2 radios <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_fnc_externalRadioVehicleListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "", "_params"];

// All radios inside a vehicle are shared
private _radioList = [_vehicle] call EFUNC(sys_data,getVehicleRadioList);
private _actions = [];
{
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName");
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");
    
    if ([_x, acre_player] call FUNC(externalRadioCheckListChildrenActions)) then {
        private _action = [_x, _displayName, _picture, {}, {true}, {_this call FUNC(externalRadioChildrenActions)}, [_x]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} forEach _radioList;

_actions
