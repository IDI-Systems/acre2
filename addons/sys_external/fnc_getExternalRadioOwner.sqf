#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Retrieves the owner of a radio that is being used externally.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * Radio owner (objNull if not in external use) <OBJECT>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_getExternalRadioOwner
 *
 * Public: No
 */

params ["_radioId"];

private _owner = [_radioId] call EFUNC(sys_radio,getRadioObject);

if !(_owner isKindOf "CAManBase") then {
    _owner = objNull;
};

_owner
