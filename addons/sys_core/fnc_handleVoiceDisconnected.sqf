#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Called when the voice server connection is lost. (The extension has already reported every
 * remote speaker as stopped; sys_io keeps asking for a new token.)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_handleVoiceDisconnected
 *
 * Public: No
 */

GVAR(lastDirectTx) = [];
GVAR(lastRxChannels) = [];
GVAR(lastExtraPositions) = [];
ACRE_LOCAL_SPEAKING = false;
ACRE_LOCAL_BROADCASTING = false;
