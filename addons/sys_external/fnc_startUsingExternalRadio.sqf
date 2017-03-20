/*
 * Author: ACRE2Team
 * Start using an external radio
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: End user <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", acre_player] call acre_sys_external_startUsingExternalRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioID", "_endUser"];

[_radioId, "setState", ["isUsedExternally", [true, _endUser]]] call EFUNC(sys_data,dataEvent);

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;

// Set it as active radio.
[_radioId] call EFUNC(api,setCurrentRadio);

private _baseRadio =  [_radioId] call EFUNC(api,getBaseRadio);
private _displayName = getText (ConfigFile >> "CfgWeapons" >> _baseRadio >> "displayName");

[format [localize LSTRING(hintTake), _displayName, name ([_radioId] call FUNC(getExternalRadioOwner))]] call EFUNC(sys_core,displayNotification);
