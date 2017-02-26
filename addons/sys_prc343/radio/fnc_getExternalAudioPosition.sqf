/*
 * Author: ACRE2Team
 * Only used if a radio has an internal speaker. Since the AN/PRC 343 has none, this function returns an
 * array of zeros and does nothing.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getExternalAudioPosition" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Array of zeros <ARRAY>
 *
 * Example:
 * [] call acre_sys_prc343_fnc_getExternalAudioPosition
 *
 * Public: No
 */
#include "script_component.hpp"

[0,0,0];
