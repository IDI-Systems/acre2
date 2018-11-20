#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for radios that are being shared by a unit.
 *
 * Arguments:
 * 0: Unit with a shared radio <OBJECT>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_external_fnc_listChildrenActions
 *
 * Public: No
 */

params ["_target"];

private _actions = [];
private _sharedRadios = [_target] call FUNC(getSharedExternalRadios);

// Add external radios in order to be able to "give" them to other players
{
    _sharedRadios pushBackUnique _x;
} forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

// Add player's radios that are shared
private _ownSharedRadios = [acre_player] call FUNC(getSharedExternalRadios);
{
    _sharedRadios pushBackUnique _x;
} forEach _ownSharedRadios;

{
    private _owner = "";
    if (_x in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        _owner = format [" (%1)", name ([_x] call FUNC(getExternalRadioOwner))];
    };

    if (_x in _ownSharedRadios) then {
        _owner = format [" (%1)", name acre_player];
    };

    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName") + _owner;
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize ELSTRING(ace_interact,channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");

    if ([_x, acre_player] call FUNC(checkListChildrenActions)) then {
        private _action = [_x, _displayName, _picture, {}, {true}, {_this call FUNC(childrenActions)}, [_x]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} forEach _sharedRadios;

_actions
