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

TRACE_1("got ptt press", _this);

if(ACRE_IS_SPECTATOR) exitWith { true };

if( GVAR(pttKeyDown) && ! isNil QGVAR(delayReleasePTT_Handle) ) then {
	[[ACRE_BROADCASTING_RADIOID, true]] call DFUNC(doHandleMultiPttKeyPressUp);
} else {
	if(GVAR(pttKeyDown)) exitWith { true };
};

if(ACRE_ACTIVE_PTTKEY == -2) then {
	
	ACRE_ACTIVE_PTTKEY = _this select 0;
	private _sendRadio = "";
	if(ACRE_ACTIVE_PTTKEY == -1) then {
		_sendRadio = ACRE_ACTIVE_RADIO;
	} else {
		private _radioList = [] call EFUNC(sys_data,getPlayerRadioList);
		if(ACRE_ACTIVE_PTTKEY <= (count _radioList)-1) then {
			if( (count ACRE_ASSIGNED_PTT_RADIOS) > 0) then {
				private _sortList = [ACRE_ASSIGNED_PTT_RADIOS, _radioList] call EFUNC(sys_data,sortRadioList);
				// This will handle cleanup automatically too
				ACRE_ASSIGNED_PTT_RADIOS = _sortList select 0;
				_radioList = _sortList select 1;
				
			};
			_sendRadio = _radioList select ACRE_ACTIVE_PTTKEY;
			[_sendRadio] call EFUNC(sys_radio,setActiveRadio);
		};
	};
    
	if(_sendRadio != "") then {
		private _on = [_sendRadio, "getOnOffState"] call EFUNC(sys_data,dataEvent);
		if(_on == 1) then {
			private _initiateRadio = [_sendRadio, "handlePTTDown"] call EFUNC(sys_data,transEvent);
            
			if(_initiateRadio) then {
				ACRE_BROADCASTING_RADIOID = _sendRadio;
				// diag_log text format["ASSIGNED ACRE_BROADCASTING_RADIOID KEYDOWN: %1", ACRE_BROADCASTING_RADIOID];
				GVAR(pttKeyDown) = true;
				
				["startRadioSpeaking", _sendRadio] call EFUNC(sys_rpc,callRemoteProcedure);
				[] call FUNC(showBroadCastHint);
			};
		};
	};
};

true