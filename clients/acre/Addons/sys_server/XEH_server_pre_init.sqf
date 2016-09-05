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
ADDON = false;
if(!isServer) exitWith {ADDON = true;};


PREP(getRadioId);
PREP(setSpectator);
PREP(remoteDebugMsg);
PREP(masterIdTracker);
PREP(collect);
PREP(onGetRadioId);
PREP(acknowledgeId);
PREP(invalidGarbageCollect);
PREP(checkServerGearDesync);



DGVAR(radioIdMap) = [[],[]];

DGVAR(collectionMap) = [];
DGVAR(repopulateGCMap) = true;
DGVAR(colletionMapIndexes) = [0,0];
DGVAR(markedForGC) = [];
DGVAR(markedForGCData) = HASH_CREATE;

DGVAR(collectionTime) = DEFAULT_COLLECTION_TIME;

DGVAR(masterIdList) = [];

DVAR(ACRE_SPECTATORS_LIST) = [];

GVAR(masterIdTable) = HASH_CREATE;
GVAR(unacknowledgedIds) = [];
GVAR(doFullSearch) = false;
GVAR(fullSearchRunning) = false;
GVAR(waitingForIdAck) = false;
GVAR(nextSearchTime) = diag_tickTime + 5;


DFUNC(doAddComponentCargo) = {
	params["_container","_type","_preset","_player","_callBack","_failCallback"];

	diag_log text format["this: %1", _this];
	_hasUnique = getNumber(configFile >> "CfgWeapons" >> _type >> "acre_hasUnique");
	if(_hasUnique == 1) then {
		_ret = [_type] call FUNC(getRadioId);
		if(_ret != -1) then {
			_uniqueComponent = format["%1_id_%2", tolower(_type), _ret];
			if(!(_uniqueComponent in GVAR(masterIdList))) then {
				PUSH(GVAR(masterIdList), _uniqueComponent);
				_dataHash = HASH_CREATE;
				HASH_SET(acre_sys_data_radioData,_uniqueComponent,_dataHash);
				PUSH(GVAR(unacknowledgedIds), _uniqueComponent);
				HASH_SET(GVAR(masterIdTable), _uniqueComponent, ARR_2(_container, _container));
				_container addItemCargoGlobal [_uniqueComponent, 1];
				[_uniqueComponent, "initializeComponent", [_type, _preset]] call EFUNC(sys_data,dataEvent);
				if(_callBack != "") then {
					[_callBack, [_uniqueComponent]+_this] call CALLSTACK(LIB_fnc_globalEvent);
				};
				_fnc = {
					_uniqueComponent = _this;
					GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_uniqueComponent];
				};
				[_fnc, _uniqueComponent] call EFUNC(sys_core,delayFrame);
				// GVAR(waitingForIdAck) = true;
			};
		} else {
			if(_failCallback != "") then {
				[_failCallback, _this] call CALLSTACK(LIB_fnc_globalEvent);
			};
		};
	} else {
		if(_failCallback != "") then {
			[_failCallback, _this] call CALLSTACK(LIB_fnc_globalEvent);
		};
	};
};


ADDON = true;