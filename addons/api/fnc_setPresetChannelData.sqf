/*
 * Author: ACRE2Team
 * Sets the full data set to be utilized for the specified preset name. You should use the return value from getPresetChannelData to provide new data to this function. Improper data will most likely break ACRE on all clients.
 * The channel number must be a valid channel for that type of radio.
 * This function must be called on all clients and the server to work properly.
 *
 * Arguments:
 * 0: Radio base type <STRING>
 * 1: Preset name <STRING>
 * 2: Channel number <NUMBER>
 * 3: Preset data <HASH>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC152", "new_preset", 4, _presetData] call acre_api_fnc_setPresetChannelData;
 *
 * Public: Yes
 */
#include "script_component.hpp"
