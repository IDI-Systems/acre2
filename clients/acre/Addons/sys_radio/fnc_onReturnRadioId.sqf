/*
	Copyright � 2010,International Development & Integration Systems, LLC
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
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
LOG("HIT CALLBACK");

params["_player", "_class", "_returnIdNumber", "_replacementId"];

private _dataHash = HASH_CREATE;

// diag_log text format["acre_sys_data_radioData: %1", acre_sys_data_radioData];

HASH_SET(acre_sys_data_radioData,_class,_dataHash);
_idRelation = [_player, _player];
HASH_SET(acre_sys_server_objectIdRelationTable, _class, _idRelation);
if(_replacementId != "") then {
	_radioData = HASH_GET(acre_sys_data_radioData, _replacementId);
	HASH_SET(acre_sys_data_radioData, _class, HASH_COPY(_radioData));
};
if(_player == acre_player) then {
	_baseRadio = _replacementId;
	if(_baseRadio == "") then {
		_baseRadio = BASECLASS(_class);
	};
	_weapons = [acre_player] call EFUNC(lib,getGear);

	//if(_baseRadio in _weapons || ("ItemRadio" in _weapons && _baseRadio == GVAR(defaultItemRadioType) ) ) then {
	TRACE_2("Check inventory", _baseRadio, _weapons);
	if((toLower _baseRadio) in (_weapons apply {toLower _x})) then {
		// Add a new radio based on the id we just got
		TRACE_3("Adding radio", _class, _baseRadio, _replacementId);

		if(_replacementId == "") then {
			// initialize the new radio
			_preset = [BASECLASS(_class)] call EFUNC(sys_data,getRadioPresetName);
			[_class, _preset] call FUNC(initDefaultRadio);

			[acre_player, _baseRadio, _class] call EFUNC(lib,replaceGear);
			[_class] call EFUNC(sys_radio,setActiveRadio);
		} else {
			[acre_player, _replacementId, _class] call EFUNC(lib,replaceGear);
			if(_replacementId == ACRE_ACTIVE_RADIO) then {
				if(!isDedicated && isServer) then {
					// need to delay setting the active radio out a frame because
					// on a self hosted, this executes before the last gear check
					// and Arma delays comitting gear changes till the next frame
					// so currently, even though we removed the old radio, it will
					// still show up in the gear list in this frame.
					_fnc = {
						[(_this select 0)] call EFUNC(sys_radio,setActiveRadio);
					};
					[_fnc, [_class]] call EFUNC(sys_core,delayFrame);
				} else {
					[_class] call EFUNC(sys_radio,setActiveRadio);
				};
			};
		};
	}  else {
		// if the radio is not added to the acre_player, the garbage collector will collect it when the
		// radio id is acknowledged below because the ID became unassociated with any world object.
		// I wish there was a more clean way to do this, but I can't think of it now, and hopefully
		// mission makers will use proper gear scripts.
		diag_log text format["%1 ACRE Warning: Radio ID %2 was returned for a non-existent baseclass (%3) in inventory, possibly removed by a gear script while requesting ID: %4", diag_tickTime, _class, _baseRadio, _weapons];
	};
	GVAR(requestingNewId) = false;
	["acre_acknowledgeId", [_class, acre_player]] call CALLSTACK(LIB_fnc_globalEvent);
};
