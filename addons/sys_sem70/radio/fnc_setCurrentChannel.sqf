/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

/*
 *  This function sets the current channel
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setCurrentChannel
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setCurrentChannel")
 *      2:  Eventdata (-> Number (New Channel))
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nothing
*/
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

//TODO: If eventData is 0 -> manual mode
_eventData params ["_channelNumber"];
private _manualChannel = ["getState", "manualChannelSelection"] call GUI_DATA_EVENT;

if (_manualChannel isEqualTo 1) then {
    private _currentMHzFrequency = ["getState", "MHzKnobPosition"] call GUI_DATA_EVENT;
    _currentMHzFrequency = _currentMHzFrequency + 30;
    private _currentkHzFrequency = ["getState", "kHzKnobPosition"] call GUI_DATA_EVENT;
    _currentkHzFrequency = _currentkHzFrequency * 25 / 1000;
    private _newFreq = _currentMHzFrequency + _currentkHzFrequency;

    private _channels = HASH_GET(_radioData, "channels");
    private _channel = HASHLIST_SELECT(_channels, _channelNumber);

    HASH_SET(_channel, "frequencyTX", _newFreq);
    HASH_SET(_channel, "frequencyRX", _newFreq);

    ["setChannelData", [_channelNumber, _channel]] call GUI_DATA_EVENT;
} else {
    // First, we check how many channels are available in total
    private _channelCount = count (HASH_GET(_radioData, "channels")) - 1;

    // Then we define our upper and lower limits
    // And write the new channel to the radioData hash
    private _newChannel = (0 max _eventData) min _channelCount;
    HASH_SET(_radioData,"currentChannel",_newChannel);
};
