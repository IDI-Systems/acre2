/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
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
            private _connectString = "0ts";
            GVAR(pipeCode) = "ACRE2Arma" callExtension _connectString;
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
                call FUNC(ts3ChannelCheck);
                GVAR(hasErrored) = false;
                INFO("Pipe opened.");
                GVAR(serverStarted) = true;
            };
        };
    } else {
        [(_this select 1)] call CBA_fnc_removePerFrameHandler;
    };
    true
};
// CHANGE: Don't initialize ACRE in editor
#ifndef DEBUG_MODE_FULL
if (isMultiplayer) then {
    [] call FUNC(connectionFnc);
    ADDPFH(DFUNC(connectionFnc), 1, []);
    GVAR(serverStarted) = true;
};
#endif

true
