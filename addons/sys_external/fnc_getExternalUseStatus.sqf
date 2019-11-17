#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Retrieves the external use status of a radio.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * Array with external use information <ARRAY>
 *   0: Shared <BOOL>
 *   1: In external use <BOOL>
 *   2: Owner <OBJECT>
 *   3: User <OBJECT>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_getExternalUseStatus
 *
 * Public: No
 */

params ["_radioId"];

private _isShared = [_radioId] call FUNC(isRadioShared);

private _owner = objNull;
private _user = objNull;

private _isUsedExternally = [_radioId] call FUNC(isExternalRadioUsed);
if (_isUsedExternally) then {
    _owner = [_radioId] call FUNC(getExternalRadioOwner);
    _user = [_radioId] call FUNC(getExternalRadioUser);
};

[_isShared, _isUsedExternally, _owner, _user]
