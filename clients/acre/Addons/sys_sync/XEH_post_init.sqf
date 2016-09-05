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
DFUNC(perFrame_Dialog) = {
	//waitUntil {time > 0}; // OK
	//6323 cutRsc ["ACRE_FrameHandlerTitle", "PLAIN"];
	
	
};

DFUNC(perFrame_Trigger) = {
	GVAR(perFrameTrigger) = createTrigger["EmptyDetector", [0,0,0], false];
	GVAR(perFrameTrigger) setTriggerActivation["ANY","PRESENT",true];
	GVAR(perFrameTrigger) setTriggerStatements[QUOTE(call FUNC(perFrame_onTriggerFrame)), "", ""];
};
*/
DFUNC(perFrame_TriggerClient) = {
	GVAR(perFrameTrigger) = createTrigger["EmptyDetector", [0,0,0], false];
	GVAR(perFrameTrigger) setTriggerActivation["ANY","PRESENT",true];
	GVAR(perFrameTrigger) setTriggerStatements[QUOTE(call FUNC(perFrame_monitorFrameRender)), "", ""];
	[] spawn {
		private _currentTickTime = diag_tickTime-2;
		waitUntil {
			[] call FUNC(perFrame_monitorFrameRender);
			if(diag_tickTime - _currentTickTime >= 1.5) then {
				_currentTickTime = diag_tickTime;
				// acre_player sideChat "setting override";
				["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
			};
			time > 0;
		};
		if(isMultiplayer) then {
			["setSoundSystemMasterOverride", [0]] call EFUNC(sys_rpc,callRemoteProcedure);
		};
	};
};

#ifdef PLATFORM_A3
[QUOTE(acreBISPFH), "oneachframe", FUNC(perFrame_onFrame)] call BIS_fnc_addStackedEventHandler;
#endif
#ifdef PLATFORM_A2
[FUNC(perFrame_onFrame), 0, []] call cba_fnc_addPerFrameHandler;
#endif
[] call FUNC(perFrame_TriggerClient);
