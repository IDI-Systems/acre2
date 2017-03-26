/*
 * Author: ACRE2Team
 * Retrieves the end user of a radio that is being used externally.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * End user (objNull if not in external use) <OBJECT>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_getExternalRadioUser
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

[_radioId, "getState", "isUsedExternally"] call EFUNC(sys_data,dataEvent) select 1
