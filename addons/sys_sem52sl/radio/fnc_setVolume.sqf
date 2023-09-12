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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_setVolume
 *
 * Public: No
 */

/*
 *  This function sets the current volume state of
 *  the radio.
 *  Depending on the possible steps of the volume
 *  for the radio, it is recommended to recheck if
 *  the actual value of the volume is in line with
 *  these steps.
 *  The range must be between 0 and 1 as well.
 *
 *  Any kind of UI changes can be inserted here
 *  as well.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setVolume
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setVolume")
 *      2:  Eventdata
 *          2.0:    Volume to set
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["_radioId", "", "_eventData", "_radioData"];

private _vol = _eventData;

if (_vol%0.20 != 0) then {
    _vol = _vol-(_vol%0.20);
};

HASH_SET(_radioData, "volume", _eventData);
TRACE_3("VOLUME SET",_radioId, _vol, _radioData);
