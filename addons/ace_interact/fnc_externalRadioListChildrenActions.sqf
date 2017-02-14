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

/* TODO:
 * - Action to return radio should not be available for other users other than the new "end user".
 */

params ["_target"];

private _actions = [];
private _sharedRadios = [_target] call EFUNC(sys_external,getSharedExternalRadios);

{
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName");
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");

    private _action = [_x, _displayName, _picture, {}, {true}, {_this call FUNC(externalRadioChildrenActions)}, [_x]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _sharedRadios;

_actions
