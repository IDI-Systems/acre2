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

TRACE_1("", _this);
/*
private["_object", "_caller", "_mutexName", "_mutex", "_lockStatus", "_remoteCall"];
_caller 	= _this select 0;
_object 	= _this select 1;
_mutexName 	= _this select 2;
if( (count _this) > 3) then {
	_remoteCall = true;
} else {
	_remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
	[ACRE_EVENT(om_d), [_caller, _object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
	LOG("Sending remote event");
	
	waitUntil { // OK
		_mutex = _object getVariable _mutexName;
		(isNil "_mutex")
	};
	
	true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
_mutex = _object getVariable _mutexName;
_lockStatus = _mutex select 0;
if( _lockStatus ) then {
	private["_lockOwner"];
	// is it locked by us, or a remote entity?

	_lockOwner = _mutex select 1;
	if(isServer) then { 
		if(_lockOwner == GVAR(serverObject)) then {
			_lockStatus = false;
		};
	} else {
		if(_lockOwner == acre_player) then {
			_lockStatus = false;
		};
	};
};

_lockStatus
*/
true