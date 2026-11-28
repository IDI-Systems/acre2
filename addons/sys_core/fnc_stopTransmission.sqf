#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Releases a PTT started with acre_sys_core_fnc_startTransmission.
 *
 * Arguments:
 * 0: Key <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_core_fnc_stopTransmission
 *
 * Public: No
 */

params ["_key"];

["tx:stop", [_key]] call EFUNC(sys_io,ext);
