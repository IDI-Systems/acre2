/*
 * Author: ACRE2Team
 * Close radio GUI when calling this function. Event rised by onUnload (PRC343_RadioDialog).
 *
 * Arguments:
 * 0: Radio ID (Unused) <STRING>
 * 1: Event with the value "getChannelData" (Unused) <STRING>
 * 2: Event data with the channel number (Unused) <NUMBER>
 * 3: Radio data (Unused) <HASH>
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [] call acre_sys_prc343_fnc_closeGui
 *
 * Public: No
 */
#include "script_component.hpp"

GVAR(currentRadioId) = -1;

true
