//fnc_ping.sqf
#include "script_component.hpp"

DFUNC(pingFunc) = {
	if(!isNull player) then {
		if(GVAR(serverStarted)) then {
			LOG("ARMA2 TO TS3: PING!");
			// diag_log text format["%1 ACRE: ping!", diag_tickTime];
			private _ret = "ACRE2Arma" callExtension "2ping:";
			if(diag_tickTime - GVAR(pongTime) > 10) then {
				hintSilent "ACRE PIPE ERROR: No ping return, attempting to reattach named pipe.";
				
				_ret = "ACRE2Arma" callExtension "4";
				GVAR(runServer) = false;
				[] spawn {
					diag_log text format["%1 ACRE PIPE ERROR: No ping return, attempting to reattach named pipe.", diag_tickTime];
					sleep 2;
					GVAR(runserver) = true;
					[] call FUNC(server);
					LOG("server started");
					GVAR(serverHandle) = ADDPFH(DFUNC(serverReadLoop), 0, []);
					[] call FUNC(ping);
				};
			};
			if(!(GVAR(runServer))) then {
				diag_log text format["%1 ACRE: Server shutting down ping loop.", COMPAT_diag_tickTime];
				[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
			};
		};
	};
	true
};
GVAR(pongTime) = diag_tickTime;
ADDPFH(DFUNC(pingFunc), 2, []);
true
