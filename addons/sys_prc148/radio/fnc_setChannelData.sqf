#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setChannelData
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

private _channels = HASH_GET(_radioData, "channels");

private _cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
_cachedChannels set[(_eventData select 0), nil];
SCRATCH_SET(_radioId, "cachedFullChannels", _cachedChannels);

HASHLIST_SET(_channels, (_eventData select 0), (_eventData select 1));

true
