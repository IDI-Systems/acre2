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
private["_presetData", "_channels", "_currentChannels", "_channelData"];
TRACE_1("INITIALIZING RADIO PRC-152", _this);

params["_radioId", "_event", "_eventData", "_radioData"];

_eventData params ["_baseName","_preset"];

_presetData = [_baseName, _preset] call EFUNC(sys_data,getPresetData);

_channels = HASH_GET(_presetData,"channels");

_currentChannels = HASH_GET(_radioData,"channels");

SCRATCH_SET(_radioId, "currentTransmissions", []);

if(isNil "_currentChannels") then {
	_currentChannels = [];
	HASH_SET(_radioData,"channels",_currentChannels);
};

for "_i" from 0 to (count _channels)-1 do {
	_channelData = HASH_COPY((_channels select _i));
	TRACE_1("Setting PRC-152 Init Channel Data", _channelData);
	PUSH(_currentChannels, _channelData);
};
HASH_SET(_radioData,"volume",1);
HASH_SET(_radioData,"currentChannel",0);
HASH_SET(_radioData,"radioOn",1);
HASH_SET(_radioData, "audioPath", "TOPAUDIO");