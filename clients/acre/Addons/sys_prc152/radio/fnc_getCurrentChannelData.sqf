/*
	Copyright � 2014,International Development & Integration Systems, LLC
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
TRACE_1("", _this);
params["_radioId", "_event", "_eventData", "_radioData"];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if(isNil "_currentChannelId") then {
	_currentChannelId = 0;
} else {
	if (_currentChannelId < 0) then {
	    _currentChannelId = 0;
	};
};
private _radioChannels = HASH_GET(_radioData,"channels");
private _currentChannelData = HASHLIST_SELECT(_radioChannels, _currentChannelId);

private _optChannelId = HASH_GET(_radioData,"optChannelId");
private _opt = HASH_GET(_radioData,"optChannelData");

TRACE_4("", _currentChannelId, _currentChannelData, _optChannelId, _opt);

if(!(isNil "_optChannelId") && !(isNil "_opt")) then {
	if(_optChannelId == _currentChannelId) then {
		{
			private["_value", "_key"];
			_key = _x;
			_value = HASH_GET(_opt, _x);

			HASH_SET(_currentChannelData, _key, _value);
		} forEach HASH_KEYS(_opt);
	};
};

private _channelType = HASH_GET(_currentChannelData, "channelMode");
private _return = HASH_CREATE;
switch _channelType do {
	case "BASIC": {
		HASH_SET(_return, "mode", "singleChannel");
		HASH_SET(_return, "frequencyTX", HASH_GET(_currentChannelData, "frequencyTX"));
		HASH_SET(_return, "frequencyRX", HASH_GET(_currentChannelData, "frequencyRX"));
		HASH_SET(_return, "power", HASH_GET(_currentChannelData, "power"));
		HASH_SET(_return, "CTCSSTx", HASH_GET(_currentChannelData, "CTCSSTx"));
		HASH_SET(_return, "CTCSSRx", HASH_GET(_currentChannelData, "CTCSSRx"));
		HASH_SET(_return, "modulation", HASH_GET(_currentChannelData, "modulation"));
		HASH_SET(_return, "encryption", HASH_GET(_currentChannelData, "encryption"));
		HASH_SET(_return, "TEK", HASH_GET(_currentChannelData, "tek"));
		HASH_SET(_return, "trafficRate", HASH_GET(_currentChannelData, "trafficRate"));
		HASH_SET(_return, "syncLength", HASH_GET(_currentChannelData, "phase"));
	};
};
_return
