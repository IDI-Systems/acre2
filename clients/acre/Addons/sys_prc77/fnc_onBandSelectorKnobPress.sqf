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

private["_currentBand", "_key", "_dir", "_newBand", "_currentTuneKnobsPosition"];

_key = _this select 1;

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
_dir = -1;
if(_key == 0) then {
	_dir = 1;
};


//Read out the current Band via DataEvent
_currentBand = GET_STATE(band);
_currentTuneKnobsPosition = GET_STATE(currentChannel);

//Define and set new knob position
_newBand = ((_currentBand + _dir) max 0) min 1;
SET_STATE_CRIT(band, _newBand);

//The setCurrentChannel Event shall be triggered as well!
["setCurrentChannel", _currentTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);


//Play sound and render dialog
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
