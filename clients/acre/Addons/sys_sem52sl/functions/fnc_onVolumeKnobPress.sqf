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

//I am not using the API for getting the volume because that could
//be different from what the internal value is based on the speaker
//the API value should be used as a modifier coefficient, not as a
//state.
params ["","_key"];

GVAR(backlightOn) = true;
GVAR(lastAction) = time;


private _currentDirection = 1;
if(_key == 0) then {
    // left click
    _currentDirection = -1;
};

private _knobPosition = ["getState", "volumeKnobPosition"] call GUI_DATA_EVENT;

private _channelKnobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;

if (_channelKnobPosition == 15) then { // programming (used to help program).
    if (GVAR(selectionDir) == 0) then {
        GVAR(selectionDir) = -1 * _currentDirection;
    } else {
        GVAR(selectionDir) = 0;
    };

    ["Acre_SEM52Knob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
} else { // Channel selected do Volume control
    private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 16;

    if(_knobPosition != _newKnobPosition) then {
        
        ["setState", ["volumeKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;
                
        //private _currentVolume = GET_STATE(volume); //["getState", "volume"] call GUI_DATA_EVENT;
        private _newVolume = abs ((_newKnobPosition - 8)/8);
        ["setVolume", _newVolume] call GUI_DATA_EVENT;
        
        ["Acre_SEM52Knob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    };
};
[MAIN_DISPLAY] call FUNC(render);
