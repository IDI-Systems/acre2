/*
 * Author: ACRE2Team
 * Set the channel number that the currently active radio is on.
 *
 * Arguments:
 * 0: Channel number <NUMBER>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = [5] call acre_api_fnc_setCurrentRadioChannelNumber;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_channelNumber"];

if( !(_channelNumber isEqualType 0)) exitWith { false };

private _radioId = [] call FUNC(getCurrentRadio);
if(_radioId == "") exitWith { false };

[_radioId, _channelNumber] call FUNC(setRadioChannel);

true
