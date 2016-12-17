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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

if (hasInterface) then {
    private _radioId    = _this select 0;
    private _remote     = _this select 5;
    if (_remote) then {
        private _fnc = {
            params ["_radioId","_previousOkRadios"];
            if (HASH_HASKEY(acre_sys_core_keyedRadioIds, _radioId)) then {
                private _vals = HASH_GET(acre_sys_core_keyedRadioIds, _radioId);
                _vals params ["_netId","_speakingId"];
                HASH_REM(acre_sys_core_keyedRadioIds, _radioId);
                private _unit = (objectFromNetId _netId);
                private _languageID = _unit getVariable [QUOTE(EGVAR(core,languageId)),0];
                [str _speakingId, _languageID, _netId, "1", _radioId] call EFUNC(sys_core,remoteStartSpeaking);
                if (!(_unit in acre_sys_core_keyedMicRadios)) then {
                    private _okRadios = [[_radioId], ([] call EFUNC(sys_data,getPlayerRadioList)) + acre_sys_core_nearRadios, false] call EFUNC(sys_modes,checkAvailability);
                    _okRadios = (_okRadios select 0) select 1;
                    _okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
                    private _dif = _previousOkRadios - _okRadios;
                    {
                        [_x, "handleEndTransmission", [_radioId]] call EFUNC(sys_data,transEvent);
                    } forEach _dif;
                };
            };
            true;
        };
        private _okRadios = [[_radioId], ([] call EFUNC(sys_data,getPlayerRadioList)) + acre_sys_core_nearRadios, false] call EFUNC(sys_modes,checkAvailability);
        _okRadios = (_okRadios select 0) select 1;
        _okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
        [_fnc, [_radioId, _okRadios]] call CBA_fnc_execNextFrame;
    } else {
        private _fnc = {
            params ["_radioId","_keyedRadios"];
            {
                private _vals = HASH_GET(acre_sys_core_keyedRadioIds, _x);
                _vals params ["_netId","_speakingId"];
                private _unit = (objectFromNetId _netId);
                REM(acre_sys_core_keyedMicRadios,_unit);
                private _languageID = _unit getVariable [QUOTE(EGVAR(core,languageId)),0];
                [str _speakingId, _languageID, _netId, "1", _x] call EFUNC(sys_core,remoteStartSpeaking);
                if (!(_unit in acre_sys_core_keyedMicRadios)) then {
                    [_radioId, "handleEndTransmission", [_x]] call EFUNC(sys_data,transEvent);
                };
            } forEach _keyedRadios;
            true;
        };
        private _keyedRadios = HASH_KEYS(acre_sys_core_keyedRadioIds);
        [_fnc, [_radioId, _keyedRadios]] call CBA_fnc_execNextFrame;
    };
};
_this call FUNC(handleSetData);
