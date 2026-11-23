#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Lists the audio devices ACRE can use. The ids go into the Microphone and Speakers / headphones
 * addon options.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * [inputs, outputs], each an array of [id, name] <ARRAY>
 *
 * Example:
 * [] call acre_api_fnc_getAudioDevices
 *
 * Public: Yes
 */

private _result = ["audio:devices", []] call EFUNC(sys_io,ext);
if (_result == "") exitWith {[[], []]};

parseSimpleArray _result
