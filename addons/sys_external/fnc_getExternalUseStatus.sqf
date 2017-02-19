/*
 * Author: ACRE2Team
 * Retrieves the external use status of a radio
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 *
 * Return Value:
 * Array with information if a radio is shared, is in external use, the owner and the end user <ARRAY>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_external_getExternalUseStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

private _isShared = [_radioId] call FUNC(isRadioShared);

private _isUsedExternally = false;
private _owner = nil;
private _user = nil;

if (_isShared) then {
    _isUsedExternally = [_radioId] call FUNC(isExternalRadioUsed);
    if (_isUsedExternally) then {
        _owner = [_radioId] call FUNC(getExternalRadioOwner);
        _user = [_radioId] call FUNC(getExternalRadioUser);
    };
};

private _externalStatus = [_isShared, _isUsedExternally, _owner, _user];

_externalStatus
