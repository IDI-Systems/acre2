/*
 * Author: ACRE2Team
 * Check if a given action is available for a specific radio and unit.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Action is available <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_external_fnc_checkListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_unit"];

private _isAvailable = true;

([_radioId] call FUNC(getExternalUseStatus)) params ["_isShared", "_isUsedExternally", "_owner", "_user"];

// Do not allow an external user to return the headset if the radio is in use
if (_isUsedExternally && (_unit != _user)) exitWith {false};

// Prevent from taking a radio that can be also heard through the intercom or directly accessible racks.
if ([_radioId, _unit] call EFUNC(sys_rack,isRadioHearable) || [_radioId, _unit] call EFUNC(sys_rack,isRadioAccessible)) exitWith {false};


_isAvailable
