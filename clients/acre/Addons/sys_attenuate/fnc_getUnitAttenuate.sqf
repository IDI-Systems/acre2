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

// this function gets the attenuation value relative *from* the provided unit *to* the acre_player
// e.g. what the local acre_player attenuation scale value is.
// returns 0-1

private _listener = acre_player;
params ["_speaker"];
private _attenuate = 0;

private _vehListener = vehicle _listener;
private _vehSpeaker = vehicle _speaker;

if(_vehListener == _vehSpeaker) then {
	private _listenerTurnedOut = isTurnedOut _listener;
	private _speakerTurnedOut = isTurnedOut _speaker;
	if(!(_listenerTurnedOut && _speakerTurnedOut)) then {
		
		private _listenerCompartment = [_listener] call EFUNC(lib,getCompartment);
		private _speakerCompartment = [_speaker] call EFUNC(lib,getCompartment);
		if(_speakerCompartment != _listenerCompartment) then {
			// acre_player sideChat format["1 lc: %1 sc: %2 %3", _listenerCompartment, _speakerCompartment, (getNumber(configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment))];
			_attenuate = ((getNumber(configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment)));
		};
		if(_speakerTurnedOut || _listenerTurnedOut) then {
			// acre_player sideChat format["2 lc: %1 sc: %2 %3", _listenerCompartment, _speakerCompartment, (getNumber(configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "ACRE" >> "attenuation" >> _speakerCompartment >> _listenerCompartment))];
			_attenuate = ([_listener] call FUNC(getVehicleAttenuation))*0.5;
		};
	};
} else {
	if(_vehListener != _listener) then {
		private _listenerTurnedOut = isTurnedOut _listener;
		if(!_listenerTurnedOut) then {
			// acre_player sideChat format["1 %1 %2", _attenuate, (1-(getNumber(configFile >> "CfgVehicles" >> (typeOf (vehicle _listener)) >> "insideSoundCoef")))];
			_attenuate = _attenuate + ([_listener] call FUNC(getVehicleAttenuation)); //((getNumber(configFile >> "CfgVehicles" >> (typeOf _vehListener) >> "insideSoundCoef")));
		};
	};
	if(_vehSpeaker != _speaker) then {
		private _speakerTurnedOut = isTurnedOut _speaker;
		if(!_speakerTurnedOut) then {
			// acre_player sideChat format["2 %1 %2", _attenuate, (1-(getNumber(configFile >> "CfgVehicles" >> (typeOf (vehicle _speaker)) >> "insideSoundCoef")))];
			_attenuate = _attenuate + ([_speaker] call FUNC(getVehicleAttenuation)); //((getNumber(configFile >> "CfgVehicles" >> (typeOf _vehSpeaker) >> "insideSoundCoef")));
		};
	};
};

(_attenuate min 1);