#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises a radio with the additional states: isShared and isUsedExternally.
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

[_radioId, false] call FUNC(allowExternalUse);
[_radioId, "setState", ["radioUsedExternally", [false, objNull]]] call EFUNC(sys_data,dataEvent);

// To prevent the GUI from being simultaneously opened
[_radioId, "setState", ["radioGuiOpened", false]] call EFUNC(sys_data,dataEvent);
