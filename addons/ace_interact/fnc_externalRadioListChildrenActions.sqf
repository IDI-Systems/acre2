/*
 * Author: ACRE2Team
 * Generates a list of actions for radios that are being shared by a unit
 *
 * Arguments:
 * 0: Unit with a shared radio <OBJECT>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_fnc_externalRadioListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

/* TODO:
 * - Implemented, needs testing: Action to return radio should not be available for other users other than the new "end user".
 */

params ["_target"];

private _actions = [];
private _sharedRadios = [_target] call EFUNC(sys_external,getSharedExternalRadios);

// Add external radios in order to be able to "give" them to other players
{
    _sharedRadios pushBackUnique _x;
} forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

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
} forEach _sharedRadios;

_actions
