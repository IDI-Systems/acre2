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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getVolume
 *
 * Public: No
 */

/*
 *  This function returns the current volume state of
 *  the radio.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getVolume
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getVolume")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      current volume (to the power of 3
 *        for cubic function)
*/

params ["", "", "", "_radioData"];

private _volume = HASH_GET(_radioData,"volume");
ISNILS(_volume,1);
_volume^3;
