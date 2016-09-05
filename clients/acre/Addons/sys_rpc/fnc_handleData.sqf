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
//fnc_handleData.sqf
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

private _message = _this;
TRACE_1("RECEIEVED RPC DATA",_message);

private _procedureCall = (_message splitString ":") select 0;
if (isNil "_procedureCall") exitWith {};

TRACE_1("PROCEDURE CALL",_procedureCall);

private _restOfMessage = _message select [(count _procedureCall) +1];
private _paramArray = _restOfMessage splitString ",";

TRACE_1("PARAMS TO PROCEDURE",_paramArray);
if(HASH_HASKEY(GVAR(procedures), _procedureCall)) then {
	private _function = HASH_GET(GVAR(procedures), _procedureCall);
	TRACE_1("!!!!!!!!!!!!_---------------------------- CALLING FUNCTION -----------------!!!!!!",_procedureCall);
	// diag_log text format["CALL FUNC: %1", _function];
	_paramArray call CALLSTACK_NAMED(_function, _procedureCall);
};

true