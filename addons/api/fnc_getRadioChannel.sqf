/*
 * Author: ACRE2Team
 * Returns the channel number of the currently active channel on the provided radio ID.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Channel number, 1-N depending on the radio <NUMBER>
 *
 * Example:
 * _currentChannel = ["ACRE_PRC152_ID_123"] call acre_api_fnc_getRadioChannel;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioId"];

if(!(_radioId isEqualType "")) exitWith { -1 };

private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);

if(isNil "_channelNumber") exitWith { nil };
_channelNumber = _channelNumber + 1;
_channelNumber
