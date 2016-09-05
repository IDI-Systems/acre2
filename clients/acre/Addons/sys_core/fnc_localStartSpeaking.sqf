/*
	Copyright © 2016,International Development & Integration Systems, LLC
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

private _onRadio = parseNumber(_this select 2);
private _radioId = _this select 3;
TRACE_1("LOCAL START SPEAKING ENTER", _this);
ACRE_LOCAL_SPEAKING = true;
if(_onRadio == 1) then {
	ACRE_LOCAL_BROADCASTING = true;
	
	if (isNil "ACRE_CustomVolumeControl") then {
		if (alive player) then {
			private _factor = .4; 
			// Shifted one lower.
			switch (acre_sys_gui_VolumeControl_Level) do {
				case -2: 	{_factor = .1};
				case -1: 	{_factor = .1};
				case 0: 	{_factor = .4};
				case 1: 	{_factor = .7};
				case 2: 	{_factor = 1};
			};
			private _currentVolume = [] call EFUNC(api,getSelectableVoiceCurve);
			if (!isNil "_currentVolume") then {
				if (_currentVolume != _factor) then  {
					[_factor] call EFUNC(api,setSelectableVoiceCurve);
				};
			};
		};
	};
} else {
	ACRE_LOCAL_BROADCASTING = false;
};
/*
_speakingId = parseNumber((_this select 0));
_netId = _this select 1;
_onRadio = parseNumber((_this select 2));
_radioId = _this select 3;
*/

//Make all the present speakers on the radio net, volume go to 0
if (!ACRE_FULL_DUPLEX) then {
	if (ACRE_BROADCASTING_RADIOID != "") then {
		GVAR(previousSortedParams) params ["_radios","_sources"];
		private["_unit","_paramArray","_canUnderstand"];
		{
			if (ACRE_BROADCASTING_RADIOID == _x) exitWith {
				{
					_unit = _x select 0;
					if(!isNull _unit) then {
						if(_unit != acre_player) then {
							_canUnderstand = [_unit] call FUNC(canUnderstand);
							_paramArray = ["r", GET_TS3ID(_unit), !_canUnderstand,1,0,1,0,false,[0,0,0]];
							CALL_RPC("updateSpeakingData", _paramArray);
						};
					};
				} forEach (_sources select _forEachIndex);
			};
		} forEach _radios;
	};
};

true