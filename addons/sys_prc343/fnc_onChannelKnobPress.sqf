/*
    Copyright © 2016, International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
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
