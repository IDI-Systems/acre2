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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getListInfo
 *
 * Public: No
 */

/*
 *  This function returns the data for the third line of the hint in the
 *  lower right corner.
 *  For most radios this is similar to the FUNC(getChannelDescription)
 *  therefore it is simply called here.
 *  Important is the return structure of this function, it must be
 *  a string
 *
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getListInfo
 *  Event raised by:
 *      - Radio Cycle
 *      - Channel fast switching
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getListInfo")
 *      2:  Eventdata
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      string
*/


_this call FUNC(getChannelDescription);
