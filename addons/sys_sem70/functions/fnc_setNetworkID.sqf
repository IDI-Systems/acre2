#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_setNetworkID
 *
 * Public: No
 */

params [["_hecto", -1], ["_deca", -1], ["_ones", -1]];
private _knobPosition = ["getState", "NetworkKnobPosition"] call GUI_DATA_EVENT;

if (_hecto < 0 || {_deca < 0} || {_ones < 0}) then {
    _hecto = _knobPosition select 0;
    _deca = _knobPosition select 1;
    _ones = _knobPosition select 2;
} else {
    private _newKnobPosition = [];
    _newKnobPosition set [0, _hecto];
    _newKnobPosition set [1, _deca];
    _newKnobPosition set [2, _ones];
    ["setState", "NetworkKnobPosition", _newKnobPosition] call GUI_DATA_EVENT;
};

private "_newNetworkID";
_newNetworkID = 100*_hecto + 10*_deca + _ones;

private _currentChannel = ["getCurrentChannel"] call GUI_DATA_EVENT;
private _channel = HASHLIST_SELECT(GET_STATE("channels"), _currentChannel);
HASH_SET(_channel, "networkID", _newNetworkID);

["setChannelData", [_currentChannel, _channel]] call GUI_DATA_EVENT;
//["setState", ["networkID", _newNetworkID]] call GUI_DATA_EVENT;
