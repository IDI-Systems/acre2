#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the local player start speaking event.
 *
 * Arguments:
 * 0: Speaking ID <STRING> (unused)
 * 1: Net id of local player object <STRING> (unused)
 * 2: On radio ("0" for false, "1" for true) <STRING>
 * 3: Radio ID if talking on radio <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [0,"0:2","1","ACRE_PRC343_ID_2"] call acre_sys_core_fnc_localStartSpeaking
 *
 * Public: No
 */

TRACE_1("LOCAL START SPEAKING ENTER", _this);
params ["", "", "_onRadio", ["_radioId", ""]];
_onRadio = _onRadio == "1";

ACRE_LOCAL_SPEAKING = true;
["acre_startedSpeaking", [acre_player, _onRadio, _radioId]] call CBA_fnc_localEvent; // [unit, on radio, radio ID]

if (_onRadio) then {
    ACRE_LOCAL_BROADCASTING = true;

    if (isNil "ACRE_CustomVolumeControl" && {alive player}) then {
        private _factor = .4;
        // Shifted one lower.
        switch (EGVAR(sys_gui,VolumeControl_Level)) do {
            case -2: {_factor = .1};
            case -1: {_factor = .1};
            case 0:  {_factor = .4};
            case 1:  {_factor = .7};
            case 2:  {_factor = 1};
        };
        private _currentVolume = [] call EFUNC(api,getSelectableVoiceCurve);
        if (!isNil "_currentVolume" && {_currentVolume != _factor}) then  {
            [_factor] call EFUNC(api,setSelectableVoiceCurve);
        };
    };
} else {
    ACRE_LOCAL_BROADCASTING = false;
};

// Make all the present speakers on the radio net, volume go to 0
if (!GVAR(fullDuplex) && {ACRE_BROADCASTING_RADIOID != ""}) then {
    GVAR(previousSortedParams) params ["_radios","_sources"];
    {
        if (ACRE_BROADCASTING_RADIOID == _x) exitWith {
            {
                private _unit = _x select 0;
                if (!isNull _unit && {_unit != acre_player}) then {
                    private _canUnderstand = [_unit] call FUNC(canUnderstand);
                    private _paramArray = ["r", GET_TS3ID(_unit), !_canUnderstand,1,0,1,0,false,[0,0,0]];
                    CALL_RPC("updateSpeakingData", _paramArray);
                };
            } forEach (_sources select _forEachIndex);
        };
    } forEach _radios;
};

true
