#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens the ACRE microphone test, which measures silence, typing and speech and suggests voice
 * activation levels. Also available from Escape → Options and the ACRE Voice map page.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_api_fnc_openMicrophoneTest
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,micTestOpen);
