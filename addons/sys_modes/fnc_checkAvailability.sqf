/*
 * Author: AUTHOR
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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

#include "script_component.hpp"

params["_list1", "_list2", ["_quick",true]];

private _foundRadios = [];

{
    private _matches = [];
    private _exit = false;
    private _radioId1 = _x;
    PUSH(_foundRadios, ARR_2(_radioId1, _matches));
    private _radio1Data = [_radioId1, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    private _mode1 = HASH_GET(_radio1Data, "mode");
    private _functionName = getText(configFile >> "CfgAcreRadioModes" >> _mode1 >> "availability");
    if(_functionName != "") then {
        private _function = missionNamespace getVariable _functionName;
        {
            private _radioId2 = _x;
            private _on = [_radioId2, "getOnOffState"] call EFUNC(sys_data,dataEvent);
            private _isAvailable = false;
            if(_on == 1) then {
                _isAvailable = [_radioId1, _radioId2] call CALLSTACK_NAMED(_function, _functionName);
                if(_isAvailable) then {
                    PUSH(_matches, _radioId2);
                };
            };
            if(_isAvailable && _quick) exitWith {};
        } forEach _list2;
        if((count _matches) > 0) then {
            if(_quick) then {
                _exit = true;
            };
        };
        if(_exit) exitWith { };
    };
} forEach _list1;

_foundRadios
