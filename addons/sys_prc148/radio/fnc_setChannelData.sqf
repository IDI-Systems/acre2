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

private ["_channels", "_cachedChannels"];
params ["_radioId", "_event", "_eventData", "_radioData"];

_channels = HASH_GET(_radioData, "channels");

_cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
_cachedChannels set[(_eventData select 0), nil];
SCRATCH_SET(_radioId, "cachedFullChannels", _cachedChannels);

HASHLIST_SET(_channels, (_eventData select 0), (_eventData select 1));

true
