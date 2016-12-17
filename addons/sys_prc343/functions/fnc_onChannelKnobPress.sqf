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
 * [ARGUMENTS] call acre_sys_prc343_fnc_onChannelKnobPress;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_handlerarray", "_knob"];

private _key = _handlerarray select 1;

private _currentDirection = -1;
if (_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
private _currentBlock = floor(_currentAbsChannel / 16);
private _currentChannel = _currentAbsChannel - _currentBlock*16;

private _newBlock = _currentBlock;
private _newChannel = _currentChannel;

if (_knob == 0) then {
    _newChannel = ((_currentChannel + _currentDirection) max 0) min 15;
    //_newChannel = ((_currentData + _currentDirection) max 0) min 15;
};

if (_knob == 1) then {

    //_totalblocks = ceil (count (([GVAR(currentRadioId), "getState", "channels"] call EFUNC(sys_data,dataEvent)) select 1)/16) - 1;
    private _channels = [GVAR(currentRadioId), "getState", "channels"] call EFUNC(sys_data,dataEvent); //is a HASH_LIST
    private _totalblocks = (ceil (count (_channels) /16) - 1);
    _newBlock = ((_currentBlock + _currentDirection) max 0) min _totalblocks;
};

private _newAbsChannel = _newBlock*16 + _newChannel;

if (_newAbsChannel != _currentAbsChannel) then {
    ["setCurrentChannel", _newAbsChannel] call GUI_DATA_EVENT;

    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
