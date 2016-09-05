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
//fnc_getPacket.sqf

#include "script_component.hpp"
private["_packet", "_data", "_header", "_id", "_received", "_type"];
_packet = copyFromClipboard;
_data = toArray _packet;
_id = "";
_received = "";
_header = "";
_type = -1;
if((count _data) >= 11) then {
	_header = toString[_data select 0, _data select 1, _data select 2];
	if(_header == PACKET_PREFIX || _header == REMOTE_PACKET_PREFIX) then {
		_type = parseNumber (toString [_data select 3]);
		for "_i" from 4 to 11 do {
			_id = _id + (toString [_data select _i]);
		};
		for "_i" from 12 to (count _data) - 1 do {
			_received = _received + (toString [_data select _i]);
		};
	};
};
[_header, _type, _id, _received]