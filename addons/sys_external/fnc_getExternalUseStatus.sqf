/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_radio_allowExternalUse
 *
 * Public: No
 */
#include "script_component.hpp"

/* TODO: External use.
* - Remove function? */

params ["_radioId"];

private _isShared = [_radioId] call FUNC(isRadioShared);
private _isUsedExternally = [_radioId] call FUNC(isExternalRadioUsed);

private _externalStatus = 0;

if (_isShared) then {
    _externalStatus = _externalStatus + 1;
};

if (_isUsedExternally) then {
    _externalStatus = _externalStatus + 1;
};

_externalStatus
