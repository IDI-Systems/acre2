/*
 * Author: ACRE2Team
 * Stop using an external radio, either returning it to the owner or giving it to another player. If target
 * is skipped, a default action to return to the owner is taken.
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: New end user/original owner <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", cursorTarget] call acre_sys_external_stopUsingExternalRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_target"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);

if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
    // simulate a key up event to end the current transmission
    [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
};

ACRE_ACTIVE_EXTERNAL_RADIOS = ACRE_ACTIVE_EXTERNAL_RADIOS - [_radioId];
[1] call EFUNC(sys_list,cycleRadios); // Change active radio

private _baseRadio =  [_radioId] call EFUNC(api,getBaseRadio);
private _displayName = getText (ConfigFile >> "CfgWeapons" >> _baseRadio >> "displayName");
[format [localize LSTRING(hintReturn), _displayName, name _owner]] call EFUNC(sys_core,displayNotification);

if (_target == _owner) then {
    // Handle remote owner
    private _message = format [localize LSTRING(hintReturnOwner), name ([_radioId] call FUNC(getExternalRadioUser)), _displayName];
    [QGVAR(stopUsingRadioLocal), [_message, _radioId], _owner] call CBA_fnc_targetEvent;
   
    // Give radio back to the owner
    [_radioId, "setState", ["isUsedExternally", [false, objNull]]] call EFUNC(sys_data,dataEvent);
} else {
    // Show a hint to the actual owner that the radio was given to another player
    private _message = format [localize LSTRING(hintGiveOwner), name ([_radioId] call FUNC(getExternalRadioUser)), _displayName, name _target];
    [QGVAR(giveRadioLocal), [_message, _radioId], _owner] call CBA_fnc_targetEvent;

    // Give radio to another player
    [QGVAR(giveRadioAction), [_radioId, _target], _target] call CBA_fnc_targetEvent;
};
