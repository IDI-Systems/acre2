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

params ["_newTs3Id","_netId"];

_newTs3Id = parseNumber _newTs3Id;

_playerObject = objectFromNetId _netId;
TRACE_1("got client ID", _this);
if(_playerObject == acre_player) then {
	_resendSpectator = false;
	if(_newTs3Id != GVAR(ts3id)) then {
		if(ACRE_IS_SPECTATOR) then {
			[] call FUNC(spectatorOff);
			_resendSpectator = true;
		};
	};
	GVAR(ts3id) = _newTs3Id;
	if(_resendSpectator) then {
		[] call FUNC(spectatorOn)
	};
	TRACE_1("SETTING TS3ID",GVAR(ts3id));
} else {
	_playerObject setVariable [QUOTE(GVAR(ts3id)), _newTs3Id, false];
};

//Ensure the incoming TS ID is pointing to the correct unit.
private _found = false;
{
	_x params ["_remoteTs3Id","_remoteUser"];
	if (_remoteTs3Id == _newTs3Id) exitWith {
		_found = true;
		if (_playerObject != _remoteUser) then {
			GVAR(playerList) set [_forEachIndex, [_newTs3Id, _playerObject]];
			//If changed remove.
			REM(GVAR(speakers),_remoteUser);
			REM(GVAR(spectatorSpeakers),_remoteTs3Id);
			REM(GVAR(keyedMicRadios),_remoteUser);
		};
		// Case where objects dont match but we found our TS ID.
	};
} forEach (GVAR(playerList));
if (!_found) then { 
	GVAR(playerList) pushBack [_newTs3Id,_playerObject];
};

true