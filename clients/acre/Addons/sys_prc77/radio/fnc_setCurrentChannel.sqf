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
private ["_currentBand", "_baseMhzFrequency", "_MHz", "_kHz", "_frequency", "_power"];
TRACE_1("", _this);

params["_radioId", "_event", "_eventData", "_radioData"];

TRACE_1("SETTING CURRENT CHANNEL",_this);

_currentBand = HASH_GET(_radioData,"band");
//Finding the MHz
//interpreting the band selector
_baseMhzFrequency = 30;
if (_currentBand == 1) then {
	_baseMhzFrequency = 53;
};
//adding the value of the KnobPosition
_MHz = _baseMhzFrequency + (_eventData select 0);
//Finding the kHz
_kHz = (_eventData select 1)*0.05;
//Making it Arma-Float-Stable
_kHz = [_kHz, 1, 2] call CBA_fnc_formatNumber;
_kHz = parseNumber _kHz;
//Combining both
_frequency = _MHz + _kHz;

if (_frequency < 34 || _frequency > 50) then {
	_power = 3500;

	if (_frequency > 53) then {
		_power = 3000;
	};
	if (_frequency > 71) then {
		_power = 2600;
	};
} else {
	_power = 4000;
};


HASH_SET(_radioData,"currentChannel",_eventData);
HASH_SET(_radioData,"frequencyTX",_frequency);
HASH_SET(_radioData,"frequencyRX",_frequency);
HASH_SET(_radioData,"power",_power);