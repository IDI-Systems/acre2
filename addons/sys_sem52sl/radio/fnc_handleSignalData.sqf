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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_handleSignalData
 *
 * Public: No
 */

/*
 *  If any processing of the incoming signal is necessary,
 *  this can be handled inside this function
 *
 *  Type of Event:
 *      Transmission
 *  Event:
 *      handleSignalData
 *  Event raised by:
 *      - Process Radio Speaker
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "handleSignalData")
 *      2:  Eventdata
 *          2.0:    Radio ID of transmitting radio
 *          2.1:    Radio ID of receiving radio
 *          2.2:    Signal Quality
 *          2.3:    Signal strength
 *          2.4:    Signal Model
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true
*/


params ["","","_eventData"];

_eventData;
