/*
 * Author: ACRE2Team
 * Returns the channel number that the currently active radio is on.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Channel number. Returns -1 if no active radio or the channel can't be found. <NUMBER>
 *
 * Example:
 * [] call acre_api_fnc_getCurrentRadioChannelNumber;
 *
 * Public: Yes
 */
#include "script_component.hpp"

private _radioId = [] call FUNC(getCurrentRadio);
if (_radioId == "") exitWith { -1 };

private _channelNumber = [_radioId] call FUNC(getRadioChannel);

if (isNil "_channelNumber") exitWith { -1 };
_channelNumber
