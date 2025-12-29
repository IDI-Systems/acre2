#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Only used if a radio has an internal speaker. Since the AN/PRC 343 has none, this function returns an
 * array of zeros and does nothing.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getExternalAudioPosition" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Array of zeros <ARRAY>
 *
 * Example:
 * ["ACRE_WS38_ID_1", "getExternalAudioPosition", [], _radioData, false] call acre_sys_ws38_fnc_getExternalAudioPosition
 *
 * Public: No
 */

[0, 0, 0];
