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

private["_fullName", "_mutex", "_fail"];
params["_mutexName"];

_fullName = ACRE_SYNC(_mutexName);
/*
if(!isServer) then {
	[ACRE_EVENT(m_l), [_mutexName, acre_player] ] call CALLSTACK(LIB_fnc_globalEvent);
} else {
	[ACRE_EVENT(m_l), [_mutexName, GVAR(serverObject)] ] call CALLSTACK(LIB_fnc_localEvent);
};*/

_fail = false;
// get the mutex, or fail if its not a valid mutex
_mutex = [_fullName] call FUNC(runScript);
if(isNil "_mutex") then { 
	_fail = true; 
};
// check if the locker is us
TRACE_1("mutex", _mutex);
_mutex params ["_locker", "_locked"];

if(_locked == 1) then {
	if(isServer) then {
		if(_locker == GVAR(serverObject)) then {
			_fail = false; 
		} else {
			_fail = true;
		};
	} else {
		if(_locker == acre_player) then {
			_fail = false; 
		} else {
			_fail = true;
		};
	};
};
TRACE_1("", _fail);
 
 TRACE_1("end", nil);
 
 // double check that our fail exit condition wasnt a bad mutex
 if(isNil "_mutex") then {
	// if it was, than we fail with "false", cause we should always just lock and block until true otherwise
	_fail = false;
 };
 
 _fail