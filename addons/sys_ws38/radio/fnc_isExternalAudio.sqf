#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Only used if a radio has an internal speaker. Since the AN/PRC 343 has none, this function returns
 * always false.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "isExternalAudio" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * False <BOOL>
 *
 * Example:
 * ["ACRE_WS38_ID_1", "isExternalAudio", [], [], false] call acre_sys_ws38_fnc_isExternalAudio
 *
 * Public: No
 */

false
