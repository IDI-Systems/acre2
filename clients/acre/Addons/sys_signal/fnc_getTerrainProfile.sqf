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

private ["_pos1","_pos2","_interval","_direction","_distance","_intervalDistance",
			"_profile","_pollPos","_alt","_lastPos"];

_pos1 = [];
_pos2 = [];
if(IS_OBJECT((_this select 0))) then {
	_pos1 = getPosASL (_this select 0);
} else {
	_pos1 = (_this select 0);
};
if(IS_OBJECT((_this select 1))) then {
	_pos2 = getPosASL (_this select 1);
} else {
	_pos2 = (_this select 1);
};
_interval = _this select 2;
_direction = ([_pos1, _pos2] call CALLSTACK(LIB_fnc_dirTo));
_distance = [_pos1, _pos2] call CALLSTACK(LIB_fnc_distance2D);
_intervalDistance = 0;
_profile = [];
_alt = [(COMPAT_getTerrainHeightASL _pos1), _intervalDistance, _pos1];

_profile set [(count _profile), _alt];
_lastPos = _pos1;
_intervalDistance = _intervalDistance + _interval;

while{_intervalDistance < _distance} do {
    _pos = [_lastPos, _interval, _direction] call CALLSTACK(LIB_fnc_relPos);
    _alt = [(COMPAT_getTerrainHeightASL _pos), _intervalDistance, _pos];
    _profile set [(count _profile), _alt];
    _intervalDistance = _intervalDistance + _interval;
    _lastPos = _pos;
};


_alt = [(COMPAT_getTerrainHeightASL _pos2), _distance, _pos2];
_profile set [(count _profile), _alt];


[_distance, _direction, _interval, _profile]