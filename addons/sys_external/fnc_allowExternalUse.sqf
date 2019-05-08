#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Mark a radio in order to enable/disable to be used by other units (external use).
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: Enable or disable sharing <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", false] call acre_sys_external_allowExternalUse
 *
 * Public: No
 */

params ["_radioId", "_allowExternalUse"];

[_radioId, "setState", ["radioShared", _allowExternalUse]] call EFUNC(sys_data,dataEvent);
