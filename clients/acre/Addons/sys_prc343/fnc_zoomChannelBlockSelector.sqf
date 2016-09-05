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
#define IN 0
#define OUT 1

params["_direction"];

{ctrlEnable [_x, false];} forEach [201, 202, 203, 204];

private _animation = SCRATCH_GET_DEF(GVAR(currentRadioId), "animation", false); //false if no animation is running
if (_animation) exitWith { [] };

if (_direction == OUT) then {
	SCRATCH_SET(GVAR(currentRadioId), "animation", true);
	private _currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
	private _currentBlock = floor(_currentAbsChannel / 16);
	private _currentChannel = _currentAbsChannel - _currentBlock*16;
	private _currentVolume = GET_STATE(volume); //from 0 to 1
	private _currentVolumeKnobState = round(_currentVolume * 5);
	private _animationhandler = [count GVAR(backgroundImages) -1,0,3,_currentVolumeKnobState,_currentChannel];

	DFUNC(zoomOut_PFH)=  {
		// Extract all variables
		params ["_paramsarray","_PFHid"];
		_paramsarray params ["_animationhandler","_radioId"];
		_animationhandler params ["_index","_channelindex","_volumeindex","_currentVolume","_currentChannel"];

		// If the CurrentRadioId is not existing (-1) -> Bug out
		if!(IS_STRING(GVAR(currentRadioId))) exitWith {
			SCRATCH_SET(_radioId, "animation", false);
			[_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent);
			[_PFHid] call EFUNC(sys_sync,perFrame_remove);
		};

		// If currentRadioId is valid, check if it is equal to the temporary ID (_radioId)
		// and run animation or bug out
		if (GVAR(currentRadioId) == _radioId) then {
			TRACE_1("Radio Id Match", _radioId);
			if(_index < 0) then {
				if(_channelindex < _currentChannel || (_currentVolume != 3 && _currentVolume != _volumeindex)) then {

					{
						(MAIN_DISPLAY displayCtrl _x) ctrlSetFade 0;
						(MAIN_DISPLAY displayCtrl _x) ctrlCommit 0;
					} forEach [106,107];


					if(_channelindex < _currentChannel) then {
						INC(_channelindex);
						_animationhandler set [1, _channelindex];
						(MAIN_DISPLAY displayCtrl 106) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\channel\prc343_ui_pre_%1.paa", _channelindex + 1];
					};
					if(_volumeindex > _currentVolume) then {
						DEC(_volumeindex);
						_animationhandler set [2, _volumeindex];
						(MAIN_DISPLAY displayCtrl 107) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\volume\prc343_ui_vol_%1.paa", _volumeindex];
					};
					if(_volumeindex < _currentVolume) then {
						INC(_volumeindex);
						_animationhandler set [2, _volumeindex];
						(MAIN_DISPLAY displayCtrl 107) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\volume\prc343_ui_vol_%1.paa", _volumeindex];
					};
				} else {
					SCRATCH_SET(_radioId, "animation", false);
					if(_currentVolume != 0) then {
						["setOnOffState", 1] call GUI_DATA_EVENT;
					};
					[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
					[_PFHid] call EFUNC(sys_sync,perFrame_remove);
				};
			} else {
					{
						(MAIN_DISPLAY displayCtrl _x) ctrlSetFade 1;
						(MAIN_DISPLAY displayCtrl _x) ctrlCommit 0;
					} forEach [106,107];

					(MAIN_DISPLAY displayCtrl 99999) ctrlSetText (GVAR(backgroundImages) select _index);
					//(MAIN_DISPLAY displayCtrl 106) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\channel\%1\acre_prc343_channelKnob_%2.paa", (_currentChannel + 1), _index];
					DEC(_index);
					_animationhandler set [0, _index];
			};
		} else {
			TRACE_2("Mismatch", _radioId, GVAR(currentRadioId));
			SCRATCH_SET(_radioId, "animation", false);
			[_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent);
			[_PFHid] call EFUNC(sys_sync,perFrame_remove);
		};
	};

	private _tempRadioId = GVAR(currentRadioId); // make sure its a copy, not a reference
	ADDPFH(DFUNC(zoomOut_PFH), 0.05,ARR_2(_animationhandler,_tempRadioId))

};


if (_direction == IN) then {
	SCRATCH_SET(GVAR(currentRadioId), "animation", true);
	private _currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
	private _currentBlock = floor(_currentAbsChannel / 16);
	private _currentChannel = _currentAbsChannel - _currentBlock*16;
	private _currentVolume = GET_STATE(volume); //from 0 to 1
	private _currentVolumeKnobState = round(_currentVolume * 5);
	private _animationhandler = [0,_currentChannel,_currentVolumeKnobState,_currentChannel]; //[30,currentchannel]
	["setOnOffState", 0] call GUI_DATA_EVENT;

	DFUNC(zoomIn_PFH) = {
		// Extract all variables
		params ["_paramsarray","_PFHid"];
		_paramsarray params ["_animationhandler","_radioId"];
		_animationhandler params ["_index","_channelindex","_volumeindex","_currentChannel"];

		// If the CurrentRadioId is not existing (-1) -> Bug out
		if!(IS_STRING(GVAR(currentRadioId))) exitWith {
			SCRATCH_SET(_radioId, "animation", false);
			[_PFHid] call EFUNC(sys_sync,perFrame_remove);
		};

		// If currentRadioId is valid, check if it is equal to the temporary ID (_radioId)
		// and run animation or bug out
		if (GVAR(currentRadioId) == _radioId) then {
			TRACE_1("Radio Id Match", _radioId);
			if (_index == (count GVAR(backgroundImages))) then {
				SCRATCH_SET(_radioId, "animation", false);
				[MAIN_DISPLAY] call CALLSTACK(FUNC(render));

				[_PFHid] call EFUNC(sys_sync,perFrame_remove);
			} else {
				if(_channelindex > 0 || _volumeindex != 3) then {

					{
						(MAIN_DISPLAY displayCtrl _x) ctrlSetFade 0;
						(MAIN_DISPLAY displayCtrl _x) ctrlCommit 0;
					} forEach [106,107];

					if(_channelindex > 0) then {
						DEC(_channelindex);
						_animationhandler set [1, _channelindex];
						(MAIN_DISPLAY displayCtrl 106) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\channel\prc343_ui_pre_%1.paa", _channelindex + 1];
					};
					if(_volumeindex < 3) then {
						INC(_volumeindex);
						_animationhandler set [2, _volumeindex];
						(MAIN_DISPLAY displayCtrl 107) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\volume\prc343_ui_vol_%1.paa", _volumeindex];
					};
					if(_volumeindex > 3) then {
						DEC(_volumeindex);
						_animationhandler set [2, _volumeindex];
						(MAIN_DISPLAY displayCtrl 107) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\volume\prc343_ui_vol_%1.paa", _volumeindex];
					};
				} else {
					{
						(MAIN_DISPLAY displayCtrl _x) ctrlSetFade 1;
						(MAIN_DISPLAY displayCtrl _x) ctrlCommit 0;
					} forEach [106,107];

					(MAIN_DISPLAY displayCtrl 99999) ctrlSetText (GVAR(backgroundImages) select _index);
					//(MAIN_DISPLAY displayCtrl 106) ctrlSetText format ["\idi\clients\acre\addons\sys_prc343\Data\knobs\channel\%1\acre_prc343_channelKnob_%2.paa", (_currentChannel + 1), _index];
					INC(_index);
					_animationhandler set [0, _index];
				};
			};
		} else {
			TRACE_2("Mismatch", _radioId, GVAR(currentRadioId));
			SCRATCH_SET(_radioId, "animation", false);
			[_PFHid] call EFUNC(sys_sync,perFrame_remove);
		};
	};

	private _tempRadioId = GVAR(currentRadioId); // make sure its a copy, not a reference
	ADDPFH(DFUNC(zoomIn_PFH), 0.05,ARR_2(_animationhandler,_tempRadioId))

};
