#include "script_component.hpp"
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

params ["_target"];

private _actions = [];
private _currentRadio = [] call EFUNC(api,getCurrentRadio);
private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
private _radioList = [] call EFUNC(api,getCurrentRadioList);

{
    private _owner = "";
    if (_x in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        _owner = format [" (%1)", name ([_x] call EFUNC(sys_external,getExternalRadioOwner))];
    };

    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;

    private "_displayName";
    if (_x in ACRE_ACCESSIBLE_RACK_RADIOS || {_x in ACRE_HEARABLE_RACK_RADIOS}) then {
        private _radioRack = [_x] call EFUNC(sys_rack,getRackFromRadio);
        private _radioClass = [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
        _displayName = getText (configFile >> "CfgAcreComponents" >> _radioClass >> "name");
    } else {
        _displayName = getText (_item >> "displayName") + _owner;
    };

    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");
    private _isActive = _x isEqualTo _currentRadio;

    private _action = [
        _x,
        _displayName,
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

if (count _radioList > 0) then {
    private _text = localize LSTRING(lowerHeadset);
    if (EGVAR(sys_core,lowered) == 1) then { _text = localize LSTRING(raiseHeadset); };
    private _action = [QGVAR(toggleHeadset), _text, "", {[] call EFUNC(sys_core,toggleHeadset)}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    if (!EGVAR(sys_core,automaticAntennaDirection)) then {
        _text = localize LSTRING(bendAntenna);
        private _dir = acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false];
        if (_dir) then { _text = localize LSTRING(straightenAntenna);};
        _action = [QGVAR(antennaDirUp), _text, "", {[] call EFUNC(sys_components,toggleAntennaDir)}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
};

_actions
