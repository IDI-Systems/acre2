/*
	Copyright � 2010,International Development & Integration Systems, LLC
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

params["_radio"];

private _side = "CENTER";

if(!(isNil "_radio")) then {
	private _isInitialized = [_radio] call EFUNC(sys_data,isRadioInitialized);
//	diag_log format["STATE WTF: %1=%2", _radio, _state];
	if(_isInitialized) then {
		private _spatial = [_radio, "getSpatial"] call EFUNC(sys_data,dataEvent);

		switch(_spatial) do {
			case -1: {
				_side = "LEFT";
			};
			case 1: {
				_side = "RIGHT";
			};
			case 0: {
				_side = "CENTER";
			};
			default {
				_side = "CENTER";
			};
		};
	};
};

_side
