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
 * [ARGUMENTS] call acre_sys_sem70_fnc_setOnOffState
 *
 * Public: No
 */

/*
 *  This function sets the current on/off state of
 *  the radio.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setOnOffState
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setOnOffState")
 *      2:  Eventdata
 *          2.0: 0/1 for off/on
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["_radioId", "", "_eventData", "_radioData"];

HASH_SET(_radioData,"radioOn",_eventData);
if (_radioId == acre_sys_radio_currentRadioDialog) then {
    if (_eventData isEqualTo 0) then {

    } else {

    };
};
