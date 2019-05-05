#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises a radio with the additional state: externalAntennaConnected.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_initRadio
 *
 * Public: No
 */

params ["_radioId"];

[_radioId, "setState", ["externalAntennaConnected", [false, objNull]]] call EFUNC(sys_data,dataEvent);
