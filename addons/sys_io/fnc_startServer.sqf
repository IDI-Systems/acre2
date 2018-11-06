#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Starts the SQF code to maintain connectivity to the TeamSpeak plugin via the ACRE2Arma extension.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Successful Start <BOOL>
 *
 * Example:
 * [] call acre_sys_io_fnc_startServer
 *
 * Public: No
 */

GVAR(hasErrored) = false;
GVAR(connectCount) = 15;

// test dsound.dll

GVAR(runserver) = true;
[] call FUNC(server);
LOG("server started");
ADDPFH(DFUNC(serverReadLoop), 0, []);
[] call FUNC(ping);


true
