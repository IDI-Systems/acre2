/*
 * Author: AUTHOR
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

private["_key", "_currentDirection", "_currentAbsChannel", "_currentBlock", "_currentChannel", "_newBlock", "_newChannel", "_newAbsChannel"];

params["_handlerarray", "_knob"];

_key = _handlerarray select 1;

_currentDirection = -1;
if(_key == 0) then {
    // left click
    _currentDirection = 1;
};

_currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
_currentBlock = floor(_currentAbsChannel / 16);
_currentChannel = _currentAbsChannel - _currentBlock*16;

_newBlock = _currentBlock;
_newChannel = _currentChannel;

if (_knob == 0) then {
    _newChannel = ((_currentChannel + _currentDirection) max 0) min 15;
    //_newChannel = ((_currentData + _currentDirection) max 0) min 15;
};

if (_knob == 1) then {
    private ["_totalblocks", "_channels"];

    //_totalblocks = ceil (count (([GVAR(currentRadioId), "getState", "channels"] call EFUNC(sys_data,dataEvent)) select 1)/16) - 1;
    _channels = [GVAR(currentRadioId), "getState", "channels"] call EFUNC(sys_data,dataEvent); //is a HASH_LIST
    _totalblocks = (ceil (count (_channels) /16) - 1);
    _newBlock = ((_currentBlock + _currentDirection) max 0) min _totalblocks;
};

_newAbsChannel = _newBlock*16 + _newChannel;

if(_newAbsChannel != _currentAbsChannel) then {
    ["setCurrentChannel", _newAbsChannel] call GUI_DATA_EVENT;

    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
