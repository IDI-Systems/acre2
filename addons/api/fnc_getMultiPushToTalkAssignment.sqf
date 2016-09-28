/*
 * Author: ACRE2Team
 * Returns the current radios assigned to Multiple Push-to-Talk keys, or Alternate PTT keys.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * The array of radio ID’s which are assigned to each PTT talk key. These are returned in order, from key 1-3 <ARRAY>
 *
 * Example:
 * _mpttRadioList = [] call acre_api_fnc_getMultiPushToTalkAssignment;
 *
 * Public: Yes
 */
#include "script_component.hpp"

//Emulate behaviour of the handleMultiPttKeyPress algorithm

private _radioLists = [+ ACRE_ASSIGNED_PTT_RADIOS, [] call EFUNC(sys_data,getPlayerRadioList)] call EFUNC(sys_data,sortRadioList);


private _returnValue = (_radioLists select 1);

_returnValue
