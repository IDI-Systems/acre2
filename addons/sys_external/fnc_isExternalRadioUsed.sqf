#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a radio is flagged as being used by another unit.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * Radio is being externally used <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_isExternalRadioUsed
 *
 * Public: No
 */

params ["_radioId"];

[_radioId, "getState", "radioUsedExternally"] call EFUNC(sys_data,dataEvent) select 0
