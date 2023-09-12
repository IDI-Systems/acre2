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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_setSpatial
 *
 * Public: No
 */

/*
 *  This function sets the spatialization state of
 *  the radio. The spatialization is set through
 *    a "setState" Event. It is generally recommended
 *    to insert a check if the values are safe for this
 *    kind of parameter.
 *    Spatial settings are -1/0/1 for left/center/right
 *    if set through the keybindings. Nevertheless
 *    they could represent any other numeric value.
 *    However this is not recommended because of possible
 *    confusion for the player.
 *
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setSpatial
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setSpatial")
 *      2:  Eventdata
 *          2.0:    Spatialization to set
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["_radioId",  "", "_eventData", "_radioData"];

private _spatial = _eventData;

if (_spatial in [-1, 0, 1]) then {
    [_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _spatial]] call EFUNC(sys_data,dataEvent);
};
