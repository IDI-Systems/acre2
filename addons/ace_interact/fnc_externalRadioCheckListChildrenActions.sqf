/*
 * Author: ACRE2Team
 * Check if a given action is available for a specific radio and unit
 *
 * Arguments:
 * 1: Unique radio ID <STRING>
 * 0: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Action is available <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_fnc_externalRadioCheckListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_unit"];

private _externalStatus = [_radioId] call EFUNC(sys_external,getExternalUseStatus);

_externalStatus params ["_isShared", "_isUsedExternally", "_owner", "_user"];

// Do not allow an external user to return the headset if the radio is in use
if (_isUsedExternally && (_unit != _user)) exitWith {false};

true
