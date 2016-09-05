//fnc_aliveMonitor.sqf
#include "script_component.hpp"

GVAR(oldMute) = 0;
GVAR(_waitTime) = 0;
DFUNC(utility_aliveStatus) = {
	// diag_log text format["%1 alive: %2 muted: %3, bis: %4", diag_tickTime, [acre_player] call FUNC(getAlive), IS_MUTED(acre_player), alive acre_player];
	_isMutedBool = IS_MUTED(acre_player);
	
	_isMuted = 0;
	if(_isMutedBool) then {
		_isMuted = 1;
	};
	if((_isMuted != GVAR(oldMute)) || (diag_tickTime > GVAR(_waitTime))) then {
		GVAR(_waitTime) = diag_tickTime + 3;
		["localMute", (str _isMuted)] call EFUNC(sys_rpc,callRemoteProcedure);
	};
	
	GVAR(oldMute) = _isMuted;
};
GVAR(_waitTime) = diag_tickTime + 3;
ADDPFH(DFUNC(utility_aliveStatus), 0, []);
true