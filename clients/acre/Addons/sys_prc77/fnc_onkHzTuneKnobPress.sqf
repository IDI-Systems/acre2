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

private["_key", "_shift", "_dir", "_currentTuneKnobsPosition", "_currentkHzKnobPosition", "_newkHzKnobPosition", "_newTuneKnobsPosition"];

_key = _this select 1;
_shift = _this select 4;

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
_dir = -1;
if(_key == 0) then {
	_dir = 1;
};

//If shift is pressed, perform a step by +-5
if(_shift) then {
_dir = _dir*5;
};

//Read out the current KnobPositions via DataEvent | need to make a full copy of the array
_currentTuneKnobsPosition = [];
_currentTuneKnobsPosition = GET_STATE(currentChannel);
_currentkHzKnobPosition = _currentTuneKnobsPosition select 1;

//Define and set new knob position
_newkHzKnobPosition = _currentkHzKnobPosition + _dir;

//Allow a jump over the null position
if (_newkHzKnobPosition > 19) then {
	_newkHzKnobPosition = 0;
};
if (_newkHzKnobPosition < 0) then {
	_newkHzKnobPosition = 19;
};

_newTuneKnobsPosition = + _currentTuneKnobsPosition;
_newTuneKnobsPosition set [1, _newkHzKnobPosition];
["setCurrentChannel", _newTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));