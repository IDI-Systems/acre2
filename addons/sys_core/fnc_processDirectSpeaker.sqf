#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the information required by TeamSpeak for a direct speech speaker.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Parameters to send to TeamSpeak <ARRAY>
 *
 * Example:
 * [unit] call acre_sys_core_fnc_processDirectSpeaker
 *
 * Public: No
 */

private ["_emitterPos", "_emitterDir"];
params ["_unit"];

private _id = GET_TS3ID(_unit);

private _bothSpectating = false;
private _isIntercomAttenuate = false;
private _directVolume = GVAR(globalVolume);
private _speakingType = "d";

if (_id in ACRE_SPECTATORS_LIST && {ACRE_IS_SPECTATOR}) then {
    _bothSpectating = true;
} else {
    private _attenuate = [_unit] call EFUNC(sys_attenuate,getUnitAttenuate);
    _directVolume = GVAR(globalVolume) * (1 - _attenuate);
    _isIntercomAttenuate = [_unit] call EFUNC(sys_attenuate,isIntercomAttenuate);
};

private _listenerPos = ACRE_LISTENER_POS;
private _listenerDir = ACRE_LISTENER_DIR;
if (_bothSpectating || {_isIntercomAttenuate}) then {
    _emitterPos = ACRE_LISTENER_POS;
    _emitterDir = ACRE_LISTENER_DIR;
} else {
    _emitterPos = (AGLtoASL (_unit modelToWorldVisual (_unit selectionPosition "head"))); //; eyePos _unit;
    _emitterDir = eyeDirection _unit;
};

if (ACRE_TEST_OCCLUSION && {!_bothSpectating} && {!_isIntercomAttenuate}) then {
    private _args = [_emitterPos, _listenerPos, _unit];
    // acre_player sideChat format["args: %1", _args];
    // _startTime = diag_tickTime;
    private _result = _args call FUNC(findOcclusion);
    _unit setVariable ["ACRE_OCCLUSION_VAL", _result];
    // _endTime = diag_tickTime;
    // _unit setVariable [QGVAR(lastPathPos), _lastResult];
    _directVolume = _directVolume*(_result);
    // hintSilent format["vol: %1\nt: %2", _directVolume, _endTime-_startTime];
};

private _emitterHeight = _emitterPos param [2, 1];

if (GVAR(isDeaf) || {_unit getVariable [QGVAR(isDisabled), false]} || {ACRE_LISTENER_DIVE == 1} || {_emitterHeight < -0.2}) then {
    _directVolume = 0.0;
} else {
    if (_isIntercomAttenuate) then {
        _speakingType = "i";
        _directVolume = [_unit] call EFUNC(sys_intercom,getVolumeIntercomUnit);
    };
};

private _canUnderstand = [_unit] call FUNC(canUnderstand);
private _params = [_speakingType, _id, !_canUnderstand, _directVolume^3, _emitterPos, _emitterDir];
TRACE_1("SPEAKING UPDATE", _params);
_params
