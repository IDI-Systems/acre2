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

params ["_vehicle"];

// All radios inside a vehicle are shared
private _radios = [_vehicle] call EFUNC(sys_core,getGear);
private _radioList = _radios select {_x call EFUNC(sys_radio,isUniqueRadio)};

{
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName");
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");

    private _action = [_x, _displayName, _picture, {}, {[_x, acre_player] call FUNC(externalRadioVehicleCheckListChildrenActions)}, {_this call FUNC(externalRadioChildrenActions)}, [_x]] call ace_interact_menu_fnc_createAction;
    [typeof _vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
} forEach _radioList;
