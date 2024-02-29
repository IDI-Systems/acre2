#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_setCurrentChannel
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

params ["_radioId", "", "_eventData", "_radioData"];
TRACE_2("setCurrentChannel",_radioID,_eventData);

private _manualChannel = HASH_GET(_radioData,"manualChannelSelection");
TRACE_1("ManualChannel",_manualChannel);

if (_manualChannel isEqualTo 1) then {
    private _currentMHzFrequency = HASH_GET(_radioData,"MHzKnobPosition");
    _currentMHzFrequency = _currentMHzFrequency + 30;
    private _currentkHzFrequency = HASH_GET(_radioData,"kHzKnobPosition");
    _currentkHzFrequency = _currentkHzFrequency * 25 / 1000;
    private _newFreq = _currentMHzFrequency + _currentkHzFrequency;

    private _channels = HASH_GET(_radioData,"channels");
    private _channel = HASHLIST_SELECT(_channels,GVAR(manualChannel));

    HASH_SET(_channel,"frequencyTX",_newFreq);
    HASH_SET(_channel,"frequencyRX",_newFreq);
    TRACE_3("",_currentMHzFrequency,_currentkHzFrequency,_newFreq);

    [_radioID,"setChannelData", [GVAR(manualChannel), _channel]] call EFUNC(sys_data,dataEvent);

    HASH_SET(_radioData,"currentChannel",GVAR(manualChannel));
} else {
    // First, we check how many channels are available in total
    private _channelCount = count (HASH_GET(_radioData,"channels")) - 1;

    // Then we define our upper and lower limits
    // And write the new channel to the radioData hash
    private _newChannel = (0 max _eventData) min _channelCount;
    HASH_SET(_radioData,"currentChannel",_newChannel);
};
