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
    private _maxChannelsCount = [_x, "getState", "channels"] call EFUNC(sys_data,dataEvent);
    TRACE_2("channels",_x,_maxChannelsCount);
    if (isNil "_maxChannelsCount") then {
        // Display frequency if single-channel radio (eg. AN/PRC-77)
        private _txData = [_x, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
        private _currentFreq = HASH_GET(_txData, "frequencyTX");
        _displayName = format ["%1 %2 MHz", _displayName, _currentFreq];
    } else {
        _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    };

    // Display radio keys in front of those which are bound
    private _radiokey = (_pttAssign find _x) + 1;
    if (_radiokey <= 3) then {
        _displayName = format ["%1: %2", _radiokey, _displayName];
    };

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
