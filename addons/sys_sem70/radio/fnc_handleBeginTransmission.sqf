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
 *  This function is called when a radio transmission is initiated.
 *  Its only purpose is to set the flag for transmission cache to false
 *
 *  Type of Event:
 *      Transmission
 *  Event:
 *      handleBeginTransmission
 *  Event raised by:
 *      - Remote Stop Speaking Event
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "handleBeginTransmission")
 *      2:  Eventdata
 *          2.0:    Radio ID of transmitting radio
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true
*/

params ["_radioId", "_event", "_eventData", "_radioData"];

SCRATCH_SET(_radioId, "cachedTransmissions", false);

true;
