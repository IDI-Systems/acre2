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
 * [ARGUMENTS] call acre_sys_sem70_fnc_handlePTTDown
 *
 * Public: No
 */

/*
 *  This function is called when a PTT key is pressed.
 *  It is used to set the PTTDown Flag to true and to
 *  decide what sounds shall be played.
 *
 *  Type of Event:
 *      Transmission
 *  Event:
 *      handlePTTDown
 *  Event raised by:
 *      - PTT key press
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "handlePTTDown")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true if radio transmits
 *      false if radio can't transmit
*/

params ["_radioId", "", "", "_radioData"];

if !([_radioId] call EFUNC(sys_radio,canUnitTransmit)) exitWith {false};

/*
 *  Insert code here if a radio can be only in receive
 *  mode or similar things. Return value shall
 *  be false in this case. Otherwise the radio will be
 *  handled as if it is transmitting.
*/

private _manualChannelSelection = [_radioId, "getState", "manualChannelSelection"] call EFUNC(sys_data,dataEvent);
if (_manualChannelSelection != 1) then {
    private _currentChannel = HASH_GET(_radioData,"currentChannel");
    private _channels = HASH_GET(_radioData,"channels");
    private _channel = HASHLIST_SELECT(_channels,_currentChannel);

    private _frequencies = HASH_GET(_channel,"frequencies");
    private _frequency = _frequencies call BIS_fnc_selectRandom;

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    [_radioId, "setChannelData", [_currentChannel, _channel]] call EFUNC(sys_data,dataEvent);
};

private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericBeep", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId,"PTTDown",true);
true
