/*
 * Author: ACRE2Team
 * Creates a PFH to monitor the ACRE2Arma extension's connection to the TeamSpeak plugin.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Successful <BOOL>
 *
 * Example:
 * [] call acre_sys_io_fnc_server
 *
 * Public: No
 */
#include "script_component.hpp"

GVAR(pipeCode) = "0";
DFUNC(connectionFnc) = {
    LOG("~~~~~~~~~~~~~CONNNNNECTION FUNNNNNNCTION CALLED!!!!!!!!!!!!!!!!!");
    if (GVAR(runServer)) then {
        if (GVAR(pipeCode) != "1") then {
            LOG("ATEEEMPTING TO OPEN PIPE!");
            // acre_player sideChat "OPEN PIPE";
            GVAR(pongTime) = diag_tickTime;
            GVAR(pipeCode) = "ACRE2Arma" callExtension "0ts"; // Connect String
            // acre_player sideChat format["RESULT: %1", GVAR(pipeCode)];
            if (GVAR(pipeCode) != "1") then {
                if (time > 15) then {
                    if (isMultiplayer) then {
                        private _warning = "WARNING: ACRE IS NOT CONNECTED TO TEAMSPEAK!";
                        hintSilent _warning;
                        GVAR(connectCount) = GVAR(connectCount) + 1;
                        if (GVAR(connectCount) > 15) then {
                            INFO_1("Pipe error: %1",GVAR(pipeCode));
                            GVAR(connectCount) = 0;
                        };
                    };
                    LOG("Client not responding, trying again.");
                };
                GVAR(serverStarted) = false;
                //diag_log text format["%1 ACRE: Pipe failed opening: %2", diag_tickTime, GVAR(pipeCode)];
            } else {
                LOG("PIPE OPENED!");
                if (GVAR(hasErrored) && isMultiplayer) then {
                    hint "ACRE HAS RECOVERED FROM A CLOSED PIPE!";
                } else {
                    hint "ACRE CONNECTED";
                };
                GVAR(hasErrored) = false;
                INFO("Pipe opened.");
                GVAR(serverStarted) = true;

                // Move TeamSpeak 3 channel if already in-game (otherwise display XEH will take care of it)
                if (!isNull (findDisplay 46)) then {
                    call FUNC(ts3ChannelMove);
                };
            };
        };
    } else {
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };
    true
};

#ifndef DEBUG_MODE_FULL
if (isMultiplayer) then {
#endif
    [] call FUNC(connectionFnc);
    ADDPFH(DFUNC(connectionFnc), 1, []);
    GVAR(serverStarted) = true;
#ifndef DEBUG_MODE_FULL
};
#endif

true
