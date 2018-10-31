#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * For a AN/PRC 343 this function is the same as acre_sys_prc343_getChannelDescription,
 * and therefore it is called here. Used in the transmission hint on the lower right corner.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "getListInfo" <STRING>
 * 2: Event data <ARRAY>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL>
 *
 * Return Value:
 * Description of the channel in the form "Block x - Channel y" <STRING>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "getListInfo", [], [], false] call acre_sys_prc343_fnc_getListInfo
 *
 * Public: No
 */

_this call FUNC(getChannelDescription);
