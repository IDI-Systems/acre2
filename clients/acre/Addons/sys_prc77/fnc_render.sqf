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
#define RADIO_CTRL(var1) (_display displayCtrl var1)
private["_currentVolume", "_currentFunction", "_currentBand", "_currentTuneKnob"];
params["_display"];


//Set Volumeknob position
_currentVolume = GET_STATE(volume);
_currentVolume = _currentVolume*10;
RADIO_CTRL(108) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\volume\prc77_volume_%1.paa", _currentVolume];

//Set Functionknob position
_currentFunction = GET_STATE(function);
RADIO_CTRL(105) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\function\prc77_function_%1.paa", _currentFunction];

//Set Bandknob position
_currentBand = GET_STATE(band);
RADIO_CTRL(109) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\band\PRC77_bandselector_%1.paa", _currentBand];
RADIO_CTRL(204) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\dials\PRC77_display_%1.paa", _currentBand];

//Set TuneKnobs position
_currentTuneKnob = GET_STATE(currentChannel);
RADIO_CTRL(202) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\dials\prc77_ui_disc_MHz_%1%2.paa", _currentBand + 1, [_currentTuneKnob select 0,2] call CBA_fnc_formatNumber];
RADIO_CTRL(203) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\dials\prc77_ui_disc_KHz_%1.paa", [(_currentTuneKnob select 1),2] call CBA_fnc_formatNumber ];

RADIO_CTRL(2021) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\knob\prc77_ui_knob_MHz_%1.paa", _currentTuneKnob select 0];
RADIO_CTRL(2031) ctrlSetText format ["\idi\clients\acre\addons\sys_prc77\Data\images\knob\prc77_ui_knob_KHz_%1.paa", _currentTuneKnob select 1];


true