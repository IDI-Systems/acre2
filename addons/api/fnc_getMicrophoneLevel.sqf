#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Current microphone level, for setting the voice activation sensitivity. -100 when silent or
 * not connected.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Level in dB <NUMBER>
 *
 * Example:
 * [] call acre_api_fnc_getMicrophoneLevel
 *
 * Public: Yes
 */

parseNumber (["audio:level", []] call EFUNC(sys_io,ext))
