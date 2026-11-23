#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Presses a PTT: starts a keyed transmission (radio, intercom, god, zeus), which replaces direct
 * speech while held. Nearby players still hear us directly unless spatial is false.
 *
 * Arguments:
 * 0: Key naming the transmission for acre_sys_core_fnc_stopTransmission <STRING>
 * 1: Speaking type (SPEAKING_TYPE_*) <NUMBER>
 * 2: Radio ID ("" if none) <STRING>
 * 3: Voice server channels <ARRAY>
 * 4: Also heard directly nearby <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC152_ID_1", 1, "ACRE_PRC152_ID_1", ["radio:singleChannel:43.10000"]] call acre_sys_core_fnc_startTransmission
 *
 * Public: No
 */

params ["_key", "_speakingType", "_radioId", "_channels", ["_spatial", true]];

private _range = [0, [] call FUNC(getDirectRange)] select _spatial;
[
    "tx:start",
    [_key, _speakingType, _radioId, _range, _channels, netId acre_player, [] call FUNC(getSpeakingLanguageId), GVAR(curveScale)]
] call EFUNC(sys_io,ext);
