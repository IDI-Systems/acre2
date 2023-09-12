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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getOnOffState
 *
 * Public: No
 */

/*
 *  This function returns the current on/off state of
 *  the radio.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getOnOffState
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getOnOffState")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      0 if the radio is off
 *      1 if the radio is on
*/

params ["", "", "", "_radioData"];

HASH_GET(_radioData, "radioOn");
