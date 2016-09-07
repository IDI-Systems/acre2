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

private ["_radioId", "_remote", "_fnc", "_vals", "_unit", "_okRadios", "_dif", "_x", "_keyedRadios"];

if(hasInterface) then {
    _radioId    = _this select 0;
    _remote     = _this select 5;
    if(_remote) then {
        _fnc = {
            params["_radioId","_previousOkRadios"];
            if(HASH_HASKEY(acre_sys_core_keyedRadioIds, _radioId)) then {
                _vals = HASH_GET(acre_sys_core_keyedRadioIds, _radioId);
                _vals params ["_netId","_speakingId"];
                HASH_REM(acre_sys_core_keyedRadioIds, _radioId);
                _unit = (objectFromNetId _netId);
                private _languageID = _unit getVariable [QUOTE(EGVAR(core,languageId)),0];
                [str _speakingId, _languageID, _netId, "1", _radioId] call EFUNC(sys_core,remoteStartSpeaking);
                if(!(_unit in acre_sys_core_keyedMicRadios)) then {
                    _okRadios = [[_radioId], ([] call EFUNC(sys_data,getPlayerRadioList)) + acre_sys_core_nearRadios, false] call EFUNC(sys_modes,checkAvailability);
                    _okRadios = (_okRadios select 0) select 1;
                    _okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
                    _dif = _previousOkRadios - _okRadios;
                    {
                        [_x, "handleEndTransmission", [_radioId]] call EFUNC(sys_data,transEvent);
                    } forEach _dif;
                };
            };
            true;
        };
        _okRadios = [[_radioId], ([] call EFUNC(sys_data,getPlayerRadioList)) + acre_sys_core_nearRadios, false] call EFUNC(sys_modes,checkAvailability);
        _okRadios = (_okRadios select 0) select 1;
        _okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
        [_fnc, [_radioId, _okRadios]] call EFUNC(sys_core,delayFrame);
    } else {
        _fnc = {
            params["_radioId","_keyedRadios"];
            {
                _vals = HASH_GET(acre_sys_core_keyedRadioIds, _x);
                _vals params ["_netId","_speakingId"];
                _unit = (objectFromNetId _netId);
                REM(acre_sys_core_keyedMicRadios,_unit);
                private _languageID = _unit getVariable [QUOTE(EGVAR(core,languageId)),0];
                [str _speakingId, _languageID, _netId, "1", _x] call EFUNC(sys_core,remoteStartSpeaking);
                if(!(_unit in acre_sys_core_keyedMicRadios)) then {
                    [_radioId, "handleEndTransmission", [_x]] call EFUNC(sys_data,transEvent);
                };
            } forEach _keyedRadios;
            true;
        };
        _keyedRadios = HASH_KEYS(acre_sys_core_keyedRadioIds);
        [_fnc, [_radioId, _keyedRadios]] call EFUNC(sys_core,delayFrame);
    };
};
_this call FUNC(handleSetData);
