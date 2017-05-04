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
#include "script_component.hpp"

params ["_radioID", "_endUser"];

private _owner = [_radioId] call FUNC(getExternalRadioOwner);
private _baseRadio =  [_radioId] call EFUNC(api,getBaseRadio);
private _displayName = getText (ConfigFile >> "CfgWeapons" >> _baseRadio >> "displayName");

// Do not flag as being externally used if it is already so (action give)
if (!([_radioId] call FUNC(isExternalRadioUsed))) then {
    [_radioId, "setState", ["isUsedExternally", [true, _endUser]]] call EFUNC(sys_data,dataEvent);

    // Manpack radios can also be used by the owner if they are not rack radios
    if ([_radioId] call EFUNC(sys_radio,isManpackRadio) && ([_radioId] call EFUNC(sys_rack,getRackFromRadio) == "")) then {
        [
            [_owner, _displayName, _radioId],
            {
                params ["_endUser", "_displayName", "_radioId"];
                if (ACRE_ACTIVE_RADIO isEqualTo _radioId) then {    // If it is the active radio.
                    // Otherwise cleanup
                    if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                        // simulate a key up event to end the current transmission
                        [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
                    };
                    [1] call EFUNC(sys_list,cycleRadios); // Change active radio
                };

                [format [localize LSTRING(hintTakeOwner), _endUser, _displayName]] call EFUNC(sys_core,displayNotification);
                ACRE_EXTERNALLY_USED_MANPACK_RADIOS pushBackUnique _radioId;
            }
        ] remoteExecCall ["bis_fnc_call", _owner];
    } else {
        // Personal radios can only be opened. There are no RX/TX capabilities.
        [
            [_owner, _displayName, _radioId],
            {
                params ["_endUser", "_displayName", "_radioId"];
                systemChat format ["RadioID %1", _radioId];
                if (ACRE_ACTIVE_RADIO isEqualTo _radioId) then {    // If it is the active radio.
                    // Otherwise cleanup
                    if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                        // simulate a key up event to end the current transmission
                        [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
                    };
                    [1] call EFUNC(sys_list,cycleRadios); // Change active radio
                };

                [format [localize LSTRING(hintTakeOwner), _endUser, _displayName]] call EFUNC(sys_core,displayNotification);
                ACRE_EXTERNALLY_USED_PERSONAL_RADIOS pushBackUnique _radioId;
            }
        ] remoteExecCall ["bis_fnc_call", _owner];
    };
};

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;

// Set it as active radio.
[_radioId] call EFUNC(api,setCurrentRadio);

[format [localize LSTRING(hintTake), _displayName, name _owner]] call EFUNC(sys_core,displayNotification);
