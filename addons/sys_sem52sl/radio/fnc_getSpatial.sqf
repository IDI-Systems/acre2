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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getSpatial
 *
 * Public: No
 */

/*
 *  This function returns the current spatial state of
 *  the radio.
 *    Basically this function gets its return value
 *    from the "ACRE_INTERNAL_RADIOSPATIALIZATION" state.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getSpatial
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getSpatial")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      current spatial setting (Number)
*/

params ["", "", "", "_radioData"];

private _spatial = HASH_GET(_radioData, "ACRE_INTERNAL_RADIOSPATIALIZATION");

if (!isNil "_spatial") exitWith { _spatial };
0
