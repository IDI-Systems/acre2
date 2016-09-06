/*
 * Author: AUTHOR
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
    if(GVAR(runServer)) then {
        if(GVAR(pipeCode) != "1") then {
            LOG("ATEEEMPTING TO OPEN PIPE!");
            // acre_player sideChat "OPEN PIPE";
            GVAR(pongTime) = diag_tickTime;
            private _connectString = "0ts";
            GVAR(pipeCode) = "ACRE2Arma" callExtension _connectString;
            // acre_player sideChat format["RESULT: %1", GVAR(pipeCode)];
            if(GVAR(pipeCode) != "1") then {
                if(time > 15) then {
                    if(isMultiplayer) then {
                        private _warning = "WARNING: ACRE IS NOT CONNECTED TO TEAMSPEAK!";
                        COMPAT_hintSilent _warning;
                        GVAR(connectCount) = GVAR(connectCount) + 1;
                        if(GVAR(connectCount) > 15) then {
                            diag_log text format["Pipe Error: %1", GVAR(pipeCode)];
                            GVAR(connectCount) = 0;
                        };
                    };
                    LOG("Client not responding, trying again.");
                };
                GVAR(serverStarted) = false;
                //diag_log text format["%1 ACRE: Pipe failed opening: %2", COMPAT_diag_tickTime, GVAR(pipeCode)];
            } else {
                LOG("PIPE OPENED!");
                if(GVAR(hasErrored) && isMultiplayer) then {
                    hint format["ACRE HAS RECOVERED FROM A CLOSED PIPE!"];
                } else {
                    hint format["ACRE CONNECTED"];
                };
                GVAR(hasErrored) = false;
                diag_log text format["%1 ACRE: Pipe opened.", COMPAT_diag_tickTime];
                GVAR(serverStarted) = true;
            };
        };
    } else {
        [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
    };
    true
};
// CHANGE: Don't initialize ACRE in editor
#ifndef DEBUG_MODE_FULL
if(isMultiplayer) then {
    [] call FUNC(connectionFnc);
    ADDPFH(DFUNC(connectionFnc), 1, []);
    GVAR(serverStarted) = true;
};
#endif

true
