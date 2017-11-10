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
 *  On a command to close the radio this function will be called.
 *
 *  Type of Event:
 *      Interact
 *  Event:
 *      closeGui
 *  Event raised by:
 *      - unLoad UI EH of RADIO_DIALOG
 *
 *  Parsed parameters:
 *      0:  Active Radio ID
 *      1:  Event (-> "openGui")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata (-> [])
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      true
*/

params ["_radioId", "", "", "", ""];
[_radioId, "setState", ["radioGuiOpened", false]] call EFUNC(sys_data,dataEvent);

GVAR(currentRadioId) = -1;

true
