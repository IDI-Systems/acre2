#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets up the per frame event handler for monitoring the local player inventory for changes.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_radio_fnc_monitorRadios
 *
 * Public: No
 */

GVAR(oldUniqueItemList) = [];
GVAR(forceRecheck) = false;
GVAR(requestingNewId) = false;

LOG("Monitor Inventory Starting");

[{
    ACRE_DATA_SYNCED &&
    {!isNil "ACRE_SERVER_INIT"} &&
    {time >= 1}
}, {
    [DFUNC(monitorRadiosPFH), 0.25, []] call CBA_fnc_addPerFrameHandler;
}, []] call CBA_fnc_waitUntilAndExecute;
