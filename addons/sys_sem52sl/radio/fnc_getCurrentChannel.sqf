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
 
/*
 *  This function returns the current channel
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getCurrentChannel
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getCurrentChannel")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      Number (zero-based) of current channel
*/
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

private _channelNumber = HASH_GET(_radioData,"currentChannel");

if (isNil "_channelNumber") then {
    _channelNumber = 0;
};

_channelNumber
