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

params["_display"];

private _knobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;

GVAR(depressedPTT) = true;
[{
	GVAR(depressedPTT) = false;
	[MAIN_DISPLAY] call FUNC(render);
}, GVAR(currentRadioId), 0.3] call CBA_fnc_waitAndExecute;

if (_knobPosition == 15) then { //programming mode
	private _step = ["getState", "programmingStep"] call GUI_DATA_EVENT;
	switch (_step) do {
		case 0: {
			[GVAR(currentRadioId), "setState", ["programmingStep",1]] call EFUNC(sys_data,dataEvent);
			private _channels = GET_STATE(channels);
			private _channel = _channels select GVAR(selectedChannel);
			private _freq = HASH_GET(_channel,"frequencyRX");
			GVAR(selectionDir) = 0;
			if (_freq < 70) then {
				GVAR(newFrequency) = _freq;
			} else {
				GVAR(newFrequency) = 46;
			};
		};
		case 1: {
			[GVAR(currentRadioId), "setState", ["programmingStep",2]] call EFUNC(sys_data,dataEvent);
			GVAR(selectionDir) = 0;
		};
		case 2: {
			// SAVE.
			private _channels = GET_STATE(channels);
			private _channel = _channels select GVAR(selectedChannel);
			HASH_SET(_channel,"frequencyRX",GVAR(newFrequency));
			HASH_SET(_channel,"frequencyTX",GVAR(newFrequency));
			["setChannelData", [GVAR(selectedChannel), _channel]] call GUI_DATA_EVENT;
		
			[GVAR(currentRadioId), "setState", ["programmingStep",0]] call EFUNC(sys_data,dataEvent);
			GVAR(selectionDir) = 0;			
		};
	
	};
};

[MAIN_DISPLAY] call FUNC(render);