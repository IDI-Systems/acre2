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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_setCurrentChannel
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

params ["", "", "_eventData", "_radioData"];

// First, we check how many channels are available in total
private _channelCount = count (HASH_GET(_radioData, "channels")) - 1;

// Then we define our upper and lower limits
// And write the new channel to the radioData hash
private _newChannel = (0 max _eventData) min _channelCount;
HASH_SET(_radioData,"currentChannel",_newChannel);

private _channelKnobPosition = _newChannel+2; // position 0 is off, 1 is last channel, so offset by 2
private _currentChannelKnobPosition = HASH_GET(_radioData,"channelKnobPosition");
if (_currentChannelKnobPosition != 1 && {_currentChannelKnobPosition != _channelKnobPosition}) then {
    HASH_SET(_radioData,"channelKnobPosition",_channelKnobPosition);
    if (GVAR(currentRadioId) isNotEqualTo -1) then { // is dialog open.
        [MAIN_DISPLAY] call FUNC(render);
    };
};
