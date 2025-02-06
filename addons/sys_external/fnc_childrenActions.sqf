#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using a radio externaly.
 *
 * Arguments:
 * 0: Unit with a shared radio <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters <ARRAY>
 *   0: Unique radio ID <STRING>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget, "", ["ACRE_PRC343_ID_1"]] call acre_sys_external_fnc_childrenActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_radio"];

private _actions = [];
private _playerOwnsRadio = acre_player == [_radio] call FUNC(getExternalRadioOwner);
private _isManpackRadio = [_radio] call EFUNC(sys_radio,isManpackRadio);

if (_playerOwnsRadio) then {
    private _text = [LLSTRING(giveHeadset), LLSTRING(giveHandset)] select _isManpackRadio;
    private _icon = [QPATHTOEF(ace_interact,data\icons\give_headset.paa), QPATHTOEF(ace_interact,data\icons\give_phone.paa)] select _isManpackRadio;

    private _action = [
        QGVAR(giveRadio),
        _text,
        _icon,
        {[_this select 2, _target] call FUNC(stopUsingExternalRadio)},
        {!([_this select 2] call FUNC(isExternalRadioUsed))},
        {},
        _radio
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} else {
    private _text = [LLSTRING(takeHeadset), LLSTRING(takeHandset)] select _isManpackRadio;
    private _icon = [QPATHTOEF(ace_interact,data\icons\headset.paa), QPATHTOEF(ace_interact,data\icons\phone.paa)] select _isManpackRadio;

    private _action = [
        QGVAR(useRadio),
        _text,
        _icon,
        {[_this select 2, acre_player] call FUNC(startUsingExternalRadio)},
        {!([_this select 2] call FUNC(isExternalRadioUsed))},
        {},
        _radio
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

// Check if we are giving or returning the headset
if ([_radio, _target] call FUNC(checkReturnGive)) then {
    private _text = [LLSTRING(returnHeadset), LLSTRING(returnHandset)] select _isManpackRadio;
    private _icon = [QPATHTOEF(ace_interact,data\icons\return_headset.paa), QPATHTOEF(ace_interact,data\icons\return_phone.paa)] select _isManpackRadio;

    private _action = [
        QGVAR(returnRadio),
        _text,
        _icon,
        {[_this select 2, _target] call FUNC(stopUsingExternalRadio)},
        {[_this select 2] call FUNC(isExternalRadioUsed)},
        {},
        _radio
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} else {
    private _text = [LLSTRING(giveHeadset), LLSTRING(giveHandset)] select _isManpackRadio;
    private _icon = [QPATHTOEF(ace_interact,data\icons\give_headset.paa), QPATHTOEF(ace_interact,data\icons\give_phone.paa)] select _isManpackRadio;

    private _action = [
        QGVAR(giveRadio),
        _text,
        _icon,
        {[_this select 2, _target] call FUNC(stopUsingExternalRadio)},
        {[_this select 2] call FUNC(isExternalRadioUsed)},
        {},
        _radio
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
