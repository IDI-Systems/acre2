#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds child actions for self-interaction.
 *
 * Arguments:
 * 0: Interaction Target (player) <OBJECT>
 *
 * Return Value:
 * ACE Child Actions <ARRAY>
 *
 * Example:
 * [player] call acre_ace_interact_fnc_radioListChildrenActions
 *
 * Public: No
 */

params ["_target"];

private _radioList = [] call EFUNC(api,getCurrentRadioList);
if (_radioList isEqualTo []) exitWith { [] }; // Quick exit if we have no radios

private _actions = [];
private _currentRadio = [] call EFUNC(api,getCurrentRadio);
private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);

{
    private _name = [_x] call EFUNC(sys_core,getDescriptiveName);
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _picture = getText (configFile >> "CfgWeapons" >> _baseRadio >> "picture");
    private _isActive = _x isEqualTo _currentRadio;

    private _action = [
        _x,
        _name,
        _picture,
        {
            [(_this select 2) select 0] call EFUNC(sys_radio,openRadio)
        },
        {true},
        {_this call FUNC(radioChildrenActions)},
        [_x, _isActive, _pttAssign]
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _radioList;

private _text = localize LSTRING(lowerHeadset);
if (EGVAR(sys_core,lowered)) then { _text = localize LSTRING(raiseHeadset); };
private _action = [QGVAR(toggleHeadset), _text, "", {[] call EFUNC(sys_core,toggleHeadset)}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

if (!EGVAR(sys_core,automaticAntennaDirection)) then {
    _text = localize LSTRING(bendAntenna);
    private _dir = acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false];
    if (_dir) then { _text = localize LSTRING(straightenAntenna);};
    _action = [QGVAR(antennaDirUp), _text, "", {[] call EFUNC(sys_components,toggleAntennaDir)}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
