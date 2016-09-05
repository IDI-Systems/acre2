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

private["_key", "_fnc", "_currentPresets"];

params["_handlerarray", "_preset"];

_key = _handlerarray select 1;

_fnc = 1; //0=Load; 1=Save
//Read out the current KnobPositions via DataEvent | need to make a full copy of the array
if(_key == 0) then {
	_fnc = 0;
};

//Select Presetarray
//Get the full Preset array [[x,y],[u,v]]
_currentPresets = GET_STATE(currentPreset);


if(_fnc == 0) exitWith {

private["_currentPreset", "_newTuneKnobsPosition"];
//Select array according to preset handler (left,right) [x,y]
_currentPreset = _currentPresets select _preset;
//Copy the new presetarray to the knobs position [x,y]
_newTuneKnobsPosition = + _currentPreset;
//Set the tuneknobsposition
["setCurrentChannel", _newTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
};


if(_fnc == 1) exitWith {
private["_currentTuneKnobsPosition", "_newPreset", "_newPresets"];
//Read out current TuneKnobsPosition
_currentTuneKnobsPosition = GET_STATE(currentChannel);
//Define new preset
_newPreset = + _currentTuneKnobsPosition;
//Write in the presets array
_newPresets = + _currentPresets;
(_newPresets select _preset) set [0, _newPreset select 0];
(_newPresets select _preset) set [1, _newPreset select 1];
SET_STATE(currentPreset, _newPresets);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};