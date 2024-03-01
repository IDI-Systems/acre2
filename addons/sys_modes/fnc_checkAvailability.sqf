#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calls the mode specific availability function and there checks if two list of radios are able to communicate with each other.
 *
 * Arguments:
 * 0: First radio list <ARRAY>
 * 1: Second radio list <ARRAY>
 * 2: Quick, only check if any radio can communicate <BOOL> (optional)
 *
 * Return Value:
 * List of Radios who can communicate <ARRAY>
 *
 * Example:
 * [[ACRE_ACTIVE_RADIO], [] call acre_sys_data_fnc_getPlayerRadioList, false] call acre_sys_modes_fnc_checkAvailability
 *
 * Public: No
 */

params ["_list1", "_list2", ["_quick", true]];

private _foundRadios = [];

{
    private _matches = [];
    private _exit = false;
    private _radioId1 = _x;
    PUSH(_foundRadios,[ARR_2(_radioId1,_matches)]);
    private _radio1Data = [_radioId1, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    private _mode1 = HASH_GET(_radio1Data,"mode");
    private _functionName = getText (configFile >> "CfgAcreRadioModes" >> _mode1 >> "availability");
    if (_functionName != "") then {
        private _function = missionNamespace getVariable _functionName;
        {
            private _radioId2 = _x;
            private _on = [_radioId2, "getOnOffState"] call EFUNC(sys_data,dataEvent);
            private _isAvailable = false;
            if (_on == 1) then {
                _isAvailable = [_radioId1, _radioId2] call CALLSTACK_NAMED(_function,_functionName);
                if (_isAvailable) then {
                    PUSH(_matches,_radioId2);
                };
            };
            if (_isAvailable && {_quick}) exitWith {};
        } forEach _list2;
        if (_matches isNotEqualTo []) then {
            if (_quick) then {
                _exit = true;
            };
        };
        if (_exit) exitWith { };
    };
} forEach _list1;

_foundRadios
