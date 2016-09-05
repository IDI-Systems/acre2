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

private["_dir","_currentFunction","_newFunction"];
params["_control", "_key"];

//Read out the key pressed (left/right mousebutton) and define the function increase/decrease
_dir = -1;
if(_key == 0) then {
    _dir = 1;
};

//Read out the currentFunction via DataEvent
_currentFunction = GET_STATE(function);

//Define and set new function
_newFunction = ((_currentFunction + _dir) max 0) min 4;
SET_STATE_CRIT(function, _newFunction);

//Handle new function
if(_newFunction != _currentFunction) then {
    ["setOnOffState", 1] call GUI_DATA_EVENT;

    if(_newFunction == 0) then {
        ["setOnOffState", 0] call GUI_DATA_EVENT;
    };
    if(_newFunction == 1) then {
        SET_STATE(squelch, 0);
        SET_STATE(CTCSSRx, 0);
        SET_STATE(CTCSSTx, 0);
    };
    if(_newFunction == 2) then {
        SET_STATE(squelch, 3);
        SET_STATE(CTCSSRx, 150);
        SET_STATE(CTCSSTx, 150);
    };
    // if(_newFunction == 3) then {
        // Retrans
    // };
    if(_newFunction == 4) then {
        private ["_eh"];
        _eh = _control ctrlAddEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(snapbackFunctionKnob))];
    };
    //Play sound and render dialog
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call CALLSTACK(FUNC(render));
};




