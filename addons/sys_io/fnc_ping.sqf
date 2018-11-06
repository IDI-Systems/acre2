#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Creates a loop to send periodic messages to the TeamSpeak plugin (via the ACRE2Arma extension) to indicate that the game is still connected.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Successful Ping <BOOL>
 *
 * Example:
 * [] call acre_sys_io_fnc_ping
 *
 * Public: No
 */

DFUNC(pingFunc) = {
    if (GVAR(serverStarted)) then {
        LOG("ARMA2 TO TS3: PING!");
        // diag_log text format["%1 ACRE: ping!", diag_tickTime];
        private _ret = "ACRE2Arma" callExtension "2ping:";
        if (diag_tickTime - GVAR(pongTime) > 10) then {
            ["ACRE PIPE ERROR: No ping return, attempting to reattach named pipe."] call EFUNC(sys_core,displayNotification);

            _ret = "ACRE2Arma" callExtension "4";
            GVAR(runServer) = false;
            [] spawn {
                INFO("Pipe error. No ping return, attempting to reattach named pipe.");
                sleep 2;
                GVAR(runserver) = true;
                [] call FUNC(server);
                LOG("server started");
                [] call FUNC(ping);
            };
        };
        if (!(GVAR(runServer))) then {
            INFO("Server shutting down ping loop.");
            [(_this select 1)] call CBA_fnc_removePerFrameHandler;
        };
    };
    true
};

GVAR(pongTime) = diag_tickTime;
[{!isNull player}, {
    ADDPFH(DFUNC(pingFunc), 2, []);
}] call CBA_fnc_waitUntilAndExecute;

true
