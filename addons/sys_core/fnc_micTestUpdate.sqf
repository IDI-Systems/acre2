#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Microphone test tick: updates the level meter, collects levels for the current phase, and
 * works out open/close levels at the end.
 *
 * The three phases measure the noise floor (silence), keyboard noise (typing without talking)
 * and speech, after noise suppression if it's on. Voice activation should open above the louder
 * of silence and typing (just silence with speech detection on, which keeps typing out anyway),
 * and close a little above the noise floor, so quiet syllables don't chop.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_micTestUpdate
 *
 * Public: No
 */

#define PHASE_SECONDS [0, 5, 6, 8]
#define PHASE_KEYS ["", "silent", "typing", "talking"]
#define PHASE_TEXT ["", LSTRING(micTest_phaseSilent), LSTRING(micTest_phaseTyping), LSTRING(micTest_phaseTalking)]

private _display = uiNamespace getVariable [QGVAR(micTestDisplay), displayNull];
if (isNull _display) exitWith {};
if (diag_tickTime - (GVAR(micTest) get "lastUpdate") < 0.03) exitWith {};
GVAR(micTest) set ["lastUpdate", diag_tickTime];

private _level = parseNumber (["audio:level", []] call EFUNC(sys_io,ext));
private _open = missionNamespace getVariable [QGVAR(voiceThreshold), -45];
private _close = missionNamespace getVariable [QGVAR(voiceThresholdClose), -50];

(_display displayCtrl 101) progressSetPosition (((_level + 80) / 70) max 0 min 1);
(_display displayCtrl 102) ctrlSetText format [localize LSTRING(micTest_meter), round _level, round _open, round _close];

private _percentile = {
    params ["_values", "_p"];
    if (_values isEqualTo []) exitWith {-100};
    private _sorted = +_values;
    _sorted sort true;
    _sorted select (floor ((count _sorted - 1) * _p))
};

private _phase = GVAR(micTest) get "phase";
private _text = "";
switch (true) do {
    case (_phase == 0): {
        _text = localize LSTRING(micTest_intro);
    };
    case (_phase in [1, 2, 3]): {
        (GVAR(micTest) get (PHASE_KEYS select _phase)) pushBack _level;
        private _left = (PHASE_SECONDS select _phase) - (diag_tickTime - (GVAR(micTest) get "phaseStart"));
        _text = format [
            "<t size='1.3'>%1/3</t><br/><t size='1.5'>%2</t><br/><br/>%3",
            _phase, localize (PHASE_TEXT select _phase), format [localize LSTRING(micTest_secondsLeft), ceil (_left max 0)]
        ];
        if (_left <= 0) then {
            if (_phase < 3) then {
                GVAR(micTest) set ["phase", _phase + 1];
                GVAR(micTest) set ["phaseStart", diag_tickTime];
            } else {
                // Results
                private _noise = [GVAR(micTest) get "silent", 0.95] call _percentile;
                private _typing = [GVAR(micTest) get "typing", 0.95] call _percentile;
                private _speech = [GVAR(micTest) get "talking", 0.7] call _percentile;
                // With speech detection on, typing doesn't open voice activation whatever its
                // level: only the background noise sets the threshold.
                private _floor = if (missionNamespace getVariable [QGVAR(speechDetection), true]) then {
                    _noise
                } else {
                    _noise max _typing
                };
                private _separable = _speech - _floor >= 6;
                private _newOpen = if (_separable) then {
                    (_floor + 4) min (_speech - 3)
                } else {
                    (_floor + _speech) / 2
                };
                _newOpen = round ((_newOpen max -80) min -10);
                private _newClose = round (((_noise + 3) max (_newOpen - 8)) min _newOpen);
                GVAR(micTest) set ["result", [_newOpen, _newClose, _separable, _noise, _typing, _speech]];
                GVAR(micTest) set ["phase", 4];
                (_display displayCtrl 110) ctrlEnable true;
                (_display displayCtrl 111) ctrlEnable true;
            };
        };
    };
    case (_phase == 4): {
        (GVAR(micTest) get "result") params ["_newOpen", "_newClose", "_separable", "_noise", "_typing", "_speech"];
        _text = format [
            localize LSTRING(micTest_result),
            round _noise, round _typing, round _speech, _newOpen, _newClose
        ];
        if (!_separable) then {
            _text = _text + "<br/><br/><t color='#FF8021'>" + localize LSTRING(micTest_notSeparable) + "</t>";
        };
    };
};
(_display displayCtrl 100) ctrlSetStructuredText parseText _text;
