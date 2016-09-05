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
// KEEP THIS IN DEBUG MODE FOR DIAGNOSTICS PURPOSES!
 
// KEEP THIS IN DEBUG MODE FOR DIAGNOSTICS PURPOSES!
#include "script_component.hpp"
// for testing below...
GVAR(pluginVersion) = _this select 0;
private ["_warn", "_str", "_isServer", "_isClient"];
_warn = false;
_isServer = false;
_isClient = false;
if(!isNil "ACRE_FULL_SERVER_VERSION") then {
	if(ACRE_FULL_SERVER_VERSION != QUOTE(VERSION)) then {
		_warn = true;
		_isServer = true;
	};
};
if(GVAR(pluginVersion) != QUOTE(VERSION_PLUGIN)) then {
	_warn = true;
	_isClient = true;
};

if(!ACRE_SPIT_VERSION) then {
	if(!isNil "ACRE_FULL_SERVER_VERSION") then {
		ACRE_SPIT_VERSION = true;
		_str = format["ACRE Version Information: Plugin:[%1], Addon:[%2], Server:[%3]",GVAR(pluginVersion), QUOTE(VERSION), ACRE_FULL_SERVER_VERSION];
		LOG(_str);
	};
};

if(_warn) then {
	ACRE_HAS_WARNED = true;
	_warning = "ACRE: Plugin version and Addon version do not match!";
	if(_isServer) then {
		_warning = "ACRE: Server version and client version do not match!";
	};
	if(_isClient && _isServer) then {
		_warning = "ACRE: Server version and client version do not match. Client does not match plugin!";
	};
	hint _warning;
	GVAR(wrongVersionIncrease) = GVAR(wrongVersionIncrease) + 1;
	_str = format["!!!!!!!!!!!!!!!!! ACRE: Mismatched plugin and addon! Plugin:[%1], Addon:[%2], Server:[%3] !!!!!!!!!!!!!!!!! ",GVAR(pluginVersion), QUOTE(VERSION), ACRE_FULL_SERVER_VERSION];
	LOG(_str);
	if(GVAR(wrongVersionIncrease) >= 5) then {
		titleText [_warning, "BLACK OUT", 15];
	};
} else {
	if(ACRE_HAS_WARNED) then {
		ACRE_HAS_WARNED = false;
		titleFadeOut 0;
	};
};

true
