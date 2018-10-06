#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Start using an external radio.
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

params ["_radioID", "_endUser"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);
private _baseRadio =  [_radioId] call EFUNC(api,getBaseRadio);
private _displayName = getText (ConfigFile >> "CfgWeapons" >> _baseRadio >> "displayName");

// Do not flag as being externally used if it is already so (action give)
if !([_radioId] call FUNC(isExternalRadioUsed)) then {
    [_radioId, "setState", ["radioUsedExternally", [true, _endUser]]] call EFUNC(sys_data,dataEvent);

    // Handle remote owner
    private _message = format [localize LSTRING(hintTakeOwner), _endUser, _displayName];
    [QGVAR(startUsingRadioLocal), [_message, _radioId], _owner] call CBA_fnc_targetEvent;
};

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;

// Set it as active radio.
[_radioId] call EFUNC(api,setCurrentRadio);

[format [localize LSTRING(hintTake), _displayName, name _owner], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
