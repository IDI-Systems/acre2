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
 * [ARGUMENTS] call acre_sys_sem70_fnc_getChannelDescription
 *
 * Public: No
 */

/*
 *  This function shall provide data to the transmission hint function
 *  The returned string will represent the last line of the hint
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getChannelDescription
 *  Event raised by:
 *      - Transmission hint
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getChannelDescription")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      String
*/

params ["_radioId", "", "", "_radioData"];

private _manualChannel = HASH_GET(_radioData,"manualChannelSelection");
private _hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _description = "";
if (_manualChannel isEqualTo 1) then {
    //private _hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    _description = format["Frequency: %1 MHz", HASH_GET(_hashData,"frequencyTX")];
} else {
    private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
    _description = format["Channel %1 -- Network ID %2", ([(_channelNumber), 1] call CBA_fnc_formatNumber), HASH_GET(_hashData,"networkID")];
};

_description
