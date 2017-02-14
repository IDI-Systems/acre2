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
 * [ARGUMENTS] call acre_sys_radio_allowExternalUse
 *
 * Public: No
 */
#include "script_component.hpp"


/* TODO: External use:
* - Flag radio as being in external use.
* - Remove from active radio list from actual ownwer.
* - ACE interaction should not display: allow external use nor disable external use.
*/

params ["_radioID", "_owner", "_endUser"];

[_radioId, "setState", ["isUsedExternally", [true, _owner, _endUser]]] call EFUNC(sys_data,dataEvent);

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;
