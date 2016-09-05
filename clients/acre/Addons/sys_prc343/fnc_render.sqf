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
#define IN 0
#define OUT 1

params["_display"];

private _currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
private _currentBlock = floor(_currentAbsChannel / 16);
private _currentChannel = _currentAbsChannel - _currentBlock*16;


//private _currentChannelKnobState = _currentChannelArray select 0; //channel from 0 to 15
private _currentVolume = GET_STATE(volume); //from 0 to 1
private _currentVolumeKnobState = round(_currentVolume * 5);
private _currentView = GET_STATE(currentView); //0(IN) or 1(OUT)

{_x ctrlEnable false;} forEach [RADIO_CTRL(201), RADIO_CTRL(202), RADIO_CTRL(203), RADIO_CTRL(204)];

private _currentViewFrame = 0;

if (_currentView == 0) then {
	_currentViewFrame = count (GVAR(backgroundImages)) - 1;

	RADIO_CTRL(203) ctrlSetPosition [(0.3 * safeZoneW + safeZoneX), (0.277 * safeZoneH + safeZoneY), 0.1*SafeZoneW, 0.5*SafeZoneW];
	RADIO_CTRL(203) ctrlCommit 0.01;

	RADIO_CTRL(203) ctrlSetTooltip "Attach handle";
	RADIO_CTRL(204) ctrlSetTooltip format ["Current channel block: %1", _currentBlock + 1];

	{
		(RADIO_CTRL(_x)) ctrlSetFade 1;
		(RADIO_CTRL(_x)) ctrlCommit 0;
	} forEach [106,107];


	RADIO_CTRL(99999) ctrlSetText (GVAR(backgroundImages) select _currentViewFrame);

	{_x ctrlEnable true;} forEach [RADIO_CTRL(203), RADIO_CTRL(204)];
} else {
	_currentViewFrame = 0;

	RADIO_CTRL(203) ctrlSetPosition [(0.35 * safeZoneW + safeZoneX), (0.377 * safeZoneH + safeZoneY), 0.07*SafeZoneW, 0.4*SafeZoneW];
	RADIO_CTRL(203) ctrlCommit 0.01;

	RADIO_CTRL(203) ctrlSetTooltip "Detach handle";
	RADIO_CTRL(204) ctrlSetTooltip "";

	{
		(RADIO_CTRL(_x)) ctrlSetFade 0;
		(RADIO_CTRL(_x)) ctrlCommit 0;
	} forEach [106,107];

	RADIO_CTRL(106) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\channel\prc343_ui_pre_%1.paa", _currentChannel + 1];
	RADIO_CTRL(107) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\volume\prc343_ui_vol_%1.paa", _currentVolumeKnobState];
	RADIO_CTRL(202) ctrlSetTooltip format ["Current Volume: %1%2", round(_currentVolume * 100), "%"];
	RADIO_CTRL(99999) ctrlSetText QUOTE(PATHTOF(Data\static\prc343_ui_backplate.paa));

	{_x ctrlEnable true;} forEach [RADIO_CTRL(201), RADIO_CTRL(202), RADIO_CTRL(203)];
};

TRACE_3("rendering", _currentChannel, _currentVolume, acre_sys_radio_currentRadioDialog);
true
