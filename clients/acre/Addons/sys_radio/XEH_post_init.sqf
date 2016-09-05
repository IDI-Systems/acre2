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

NO_DEDICATED;


	
// setup CBA keys for moving the radio from left to right ear and center
// [QUOTE(ADDON), "RadioSpatial_Left", { ["LEFT"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);
// [QUOTE(ADDON), "RadioSpatial_Right", { ["RIGHT"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);
// [QUOTE(ADDON), "RadioSpatial_Center", { ["CENTER"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);

// radio claiming handler
[QUOTE(GVAR(returnRadioId)), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);
//[QUOTE(GVAR(returnReplaceRadioId)), { [(_this select 0), (_this select 1), (_this select 2)] call FUNC(onReturnReplacementRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);

["acre_handleDesyncCheck", { _this call FUNC(handleDesyncCheck) }] call CALLSTACK(LIB_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK