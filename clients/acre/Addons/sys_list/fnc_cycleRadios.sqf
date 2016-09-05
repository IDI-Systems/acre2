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
 
//fnc_cycleRadios.sqf
#include "script_component.hpp"
LOG("HIT CYCLE RADIO");
if(!dialog) then {
	private["_radios", "_count", "_newRadioIndex", "_activeRadio", "_activateRadio", "_oblix",
	"_listInfo", "_baseConfig", "_realRadio", "_typeName", "_radio", "_radioClass", "_radioList"];
	params["_direction"];
	_radios = [];
	_count = 0;
	_newRadioIndex = 0;
	// populate from local radio list
	_radioList = ([] call EFUNC(sys_data,getPlayerRadioList));
	{
		_radioClass = _x;
		_listInfo = [_radioClass, "getListInfo"] call EFUNC(sys_data,dataEvent);
		_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _radioClass);
		_realRadio = configName ( _baseConfig );
		_typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
		_radio = [_typeName, _listInfo, _radioClass];
		TRACE_2("heh", _radioClass, ACRE_ACTIVE_RADIO);
		if(_radioClass == ACRE_ACTIVE_RADIO) then {
			TRACE_1("found index", _count);
			_newRadioIndex = _count;
		};
		_radios pushBack _radio;
		_count = _count + 1;
	} foreach _radioList;
	TRACE_1("index was", _newRadioIndex);
	TRACE_1("Active was", ACRE_ACTIVE_RADIO);
	if((count _radios) > 1) then {
		if(_direction == 1) then {
			if(_newRadioIndex >= (count _radios)-1) then {
				_newRadioIndex = 0;
			} else {
				_newRadioIndex = _newRadioIndex + 1;
			};
		} else {
			if(_newRadioIndex <= 0) then {
				_newRadioIndex = (count _radios) - 1;
			} else {
				_newRadioIndex = _newRadioIndex - 1;
			};
		};
		TRACE_1("radios are", _radios);
		TRACE_1("index is", _newRadioIndex);
		_activateRadio = _radios select _newRadioIndex;
		TRACE_1("Active is now", _activateRadio);
		[(_activateRadio select 2)] call EFUNC(sys_radio,setActiveRadio);
		//diag_log "GO GO GOGO";
		//diag_log text format["'%1'", _activateRadio];
		[(_activateRadio select 0), (_activateRadio select 1), "", 1] call FUNC(displayHint);
	};
};

false