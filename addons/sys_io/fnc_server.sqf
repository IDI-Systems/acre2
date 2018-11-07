#include "script_component.hpp"
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
                        if ((missionNamespace getVariable [QGVAR(notConnectedTime), -15]) + 30 < time ) then {
                            GVAR(notConnectedTime) = time;
                            private _warning = "<t color='#FF8021'>WARNING!</t><br />ACRE is not connected to Teamspeak!";
                            [_warning, 3] call EFUNC(sys_core,displayNotification);
                        };
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
                    ["<t color='#2B7319'>ACRE has recovered from a closed pipe!</t>", 3] call EFUNC(sys_core,displayNotification);
                } else {
                    ["<t color='#2B7319'>ACRE connected</t>"] call EFUNC(sys_core,displayNotification);
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
