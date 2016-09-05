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

private _currentDirection = -0.2;
if(_key == 0) then {
    // left click
    _currentDirection = 0.2;
};

private _currentVolume = GET_STATE(volume); //["getState", "volume"] call GUI_DATA_EVENT;
private _newVolume = ((_currentVolume + _currentDirection) max 0) min 1;

if(_currentVolume != _newVolume) then {
    ["Acre_GenericClick", [0,0,0], [0,0,0], _newVolume^3, false] call EFUNC(sys_sounds,playSound);
    ["setVolume", _newVolume] call GUI_DATA_EVENT;


    [MAIN_DISPLAY] call FUNC(render);

    if(_newVolume < 0.2) then {
        ["setOnOffState", 0] call GUI_DATA_EVENT;
    } else {
        if(_newVolume > 0 && _currentVolume < 0.2) then {
            ["setOnOffState", 1] call GUI_DATA_EVENT;
        };
    };
};
