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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_setChannelData
 *
 * Public: No
 */

/*
 *  Via this function the data of a specific channel
 *  can be changed. It is used mostly for radios which are
 *  capable of ingame-programming. For this example it is not
 *  used at all.
 *
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setChannelData
 *  Event raised by:
 *      - No specific function
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setChannelData")
 *      2:  Eventdata
 *          2.x: Data to be parsed (changed)
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["",  "", "_eventData", "_radioData"];

private _channels = HASH_GET(_radioData,"channels");

HASHLIST_SET(_channels,(_eventData select 0),(_eventData select 1));

true
