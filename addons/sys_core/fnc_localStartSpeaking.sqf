#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the local player start speaking event.
 *
 * Arguments:
 * 0: Speaking ID <STRING> (unused)
 * 1: Net id of local player object <STRING> (unused)
 * 2: Speaking Type <STRING>
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

TRACE_1("LOCAL START SPEAKING ENTER",_this);
params ["", "", "_speakingType", ["_radioId", ""]];

if (!(_speakingType isEqualType 0)) then { _speakingType = parseNumber _speakingType; };

private _onRadio = _speakingType == SPEAKING_TYPE_RADIO;

ACRE_LOCAL_SPEAKING = true;
["acre_startedSpeaking", [acre_player, _onRadio, _radioId, _speakingType]] call CBA_fnc_localEvent; // [unit, speaking type, radio ID]

if (_onRadio) then {
    ACRE_LOCAL_BROADCASTING = true;

    // Hear ourselves on our other radios on this channel: the speaking loop processes us like a
    // remote speaker on this radio (the voice extension plays our transmission back locally).
    if (GVAR(selfHearing)) then {
        acre_player setVariable [QGVAR(currentSpeakingRadio), _radioId];
        GVAR(hearingSelf) = acre_player;
        GVAR(speaking_cache_valid) = false;
    };

    // Shift volume down by 25% (one step) when not using a custom voice curve
    if (isNil "ACRE_CustomVolumeControl") then {
        [EGVAR(sys_gui,volumeLevel) - 0.25] call EFUNC(sys_gui,setVoiceCurveLevel);
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
                    ["speaker:radio", [GET_TS3ID(_unit), !_canUnderstand, [[0, 1, false, [0, 0, 0]]]]] call EFUNC(sys_io,ext);
                };
            } forEach (_sources select _forEachIndex);
        };
    } forEach _radios;
};

true
