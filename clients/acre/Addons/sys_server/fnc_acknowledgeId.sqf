//fnc_acknowledgeId.sqf
#include "script_component.hpp"

params["_class","_player"];

if((GVAR(unacknowledgedIds) find _class) != -1) then {
	if(!isDedicated) then {
		if(isServer && acre_player == _player) then {
			private _fnc = {
				_class = _this;
				GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
			};
			[_fnc, _class] call EFUNC(sys_core,delayFrame);
		};
	} else {
		GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
	};
} else {
	diag_log text format["%1 ACRE ERROR: %2 attempted to acknowledge ID %3 which was not awaiting acknowledgement!", diag_tickTime, _player, _class];
};
