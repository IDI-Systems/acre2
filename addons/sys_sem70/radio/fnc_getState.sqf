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
 * [ARGUMENTS] call acre_sys_sem70_fnc_getState
 *
 * Public: No
 */

/*
 *  This function is basically a wrapper for getting the content
 *  of the radioData hash for the eventData key.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getState
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getState")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      Hash Value
*/

params ["", "", "_eventData", "_radioData"];

//TRACE_4("getState",_radioData,_event,_eventData,_radioData);

HASH_GET(_radioData,_eventData);
