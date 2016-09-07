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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

/*
 *  This function is basically a wrapper for setting the content
 *  of the radioData hash with a two-parameter EventData
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setState
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setState")
 *      2:  Eventdata (-> [KEY,VALUE])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nothing
*/

params ["_radioId","_event", "_eventData", "_radioData"];

HASH_SET(_radioData, _eventData param [0], _eventData param [1]);
