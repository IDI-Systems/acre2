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

/*
 * 	On a command to open the radio this function will be called.
 *
 *	Type of Event:
 *		Interact
 *	Event:
 *		openGui
 *	Event raised by:
 *		- Double Click on Radio in inventory
 *		- Press of keybinding of the "open radio" action
 *
 * 	Parsed parameters:
 *		0:	Active Radio ID
 *		1:	Event (-> "openGui")
 *		2:	Eventdata (-> [])
 *		3:	Radiodata (-> [])	
 *		4:	Remote Call (-> false)
 *
 *	Returned parameters:
 *		true
*/

disableSerialization;
//PARAMS_1(GVAR(currentRadioId))
GVAR(currentRadioId) = _this select 0;
GVAR(depressedPTT) = false;
if (([GVAR(currentRadioId), "getState", "channelKnobPosition"] call EFUNC(sys_data,dataEvent)) == 15) then { // is programming
	GVAR(backlightOn) = true;
} else {
	GVAR(backlightOn) = false;
};
GVAR(lastAction) = time;
createDialog "SEM52SL_RadioDialog";

// Use this to turn off the backlight display//also to save last channel

[{
	params ["_input","_pfhID"];
	
	
	if (GVAR(currentRadioId) isEqualTo -1) then {_input set [1,false]}; // Remove PFH on exit.
	_input params ["_radioId","_open"];
	if (_open) then { _input set [2,GVAR(lastAction)]; };
	private _lastAction = _input select 2;
	
	if (_lastAction+3 < time) then {
		// Do not shut whilst on the programming page.
		diag_log ["Call getState channelKnobPosition ",_radioId];
		if (([_radioId, "getState", "channelKnobPosition"] call EFUNC(sys_data,dataEvent)) != 15) then {
			if (GVAR(backlightOn)) then {
				GVAR(backlightOn) = false;
				private _currentChannel = ([_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent));
				[_radioId, "setState", ["lastActiveChannel", _currentChannel]] call EFUNC(sys_data,dataEvent);
				
				if (_open) then {
					[MAIN_DISPLAY] call FUNC(renderDisplay);
				};
			};
		};
		if (!_open) then { [_pfhID] call CBA_fnc_removePerFrameHandler; };
	};
}, 1, [GVAR(currentRadioId),true,0]] call CBA_fnc_addPerFrameHandler;

true