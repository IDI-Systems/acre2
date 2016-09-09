/*
 * Author: ACRE2Team
 * Gets the current delay value for releasing radio PTT events. The default value for this is 200ms, or 0.2
 *
 * Arguments:
 * None
 *
 * Return Value:
 * The delay time in seconds to release PTT radio events. <NUMBER>
 *
 * Example:
 * _delay = [] call acre_api_fnc_getPTTDelay
 *
 * Public: Yes
 */
#include "script_component.hpp"

ACRE_PTT_RELEASE_DELAY
