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
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
private["_ret", "_parent", "_parentCheck", "_isAcre"];
params["_radioId", "_radioType"];

_ret = false;
_parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
	_parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};

_isAcre = getNumber (configFile >> "CfgAcreComponents" >> _parent >> "isAcre");
// diag_log text format["_radioId: %1 isAcre: %2", _parent, _isAcre];
TRACE_2("", _parent, _isAcre);
if(_isAcre == 0) exitWith {
	false
};
TRACE_2("", _parent, _parentCheck);

if(_parent == _radioType) exitWith { 
	true
};

if(_parent == "") then {
	_parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};

if(_parent == _radioType) exitWith { 
	true
};

while { _parent != "" } do {
	if(_parent == _radioType) exitWith {
		TRACE_2("", _parent, _radioType);
		true
	};
	_parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _parent));
};

_ret