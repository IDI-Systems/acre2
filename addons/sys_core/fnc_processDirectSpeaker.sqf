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

private ["_emitterPos", "_emitterDir"];
params ["_unit"];

private _id = GET_TS3ID(_unit);

private _bothSpectating = false;
private _isCrewAttenuate = false;
private _directVolume = GVAR(globalVolume);
private _speakingType = "d";

if (_id in ACRE_SPECTATORS_LIST && ACRE_IS_SPECTATOR) then {
    _bothSpectating = true;
} else {
    private _attenuate = [_unit] call EFUNC(sys_attenuate,getUnitAttenuate);
    _directVolume = GVAR(globalVolume) * (1-_attenuate);
    _isCrewAttenuate = [_unit] call EFUNC(sys_attenuate,isCrewIntercomAttenuate);
};

private _listenerPos = ACRE_LISTENER_POS;
private _listenerDir = ACRE_LISTENER_DIR;
if (_bothSpectating || _isCrewAttenuate) then {
    _emitterPos = ACRE_LISTENER_POS;
    _emitterDir = ACRE_LISTENER_DIR;
} else {
    _emitterPos = (AGLtoASL (_unit modelToWorldVisual (_unit selectionPosition "head"))); //; eyePos _unit;
    _emitterDir = eyeDirection _unit;
};
if (ACRE_TEST_OCCLUSION && !_bothSpectating && !_isCrewAttenuate) then {
    _args = [_emitterPos, _listenerPos, _unit];
    // acre_player sideChat format["args: %1", _args];
    // _startTime = diag_tickTime;
    _result = _args call FUNC(findOcclusion);
    _unit setVariable ["ACRE_OCCLUSION_VAL", _result];
    // _endTime = diag_tickTime;
    // _unit setVariable [QGVAR(lastPathPos), _lastResult];
    _directVolume = _directVolume*(_result);
    // hintSilent format["vol: %1\nt: %2", _directVolume, _endTime-_startTime];
};

private _emitterHeight = _emitterPos param [2, 1];

if (GVAR(isDeaf) || (_unit getVariable [QGVAR(isDisabled), false]) || (ACRE_LISTENER_DIVE == 1) || _emitterHeight < -0.2) then {
    _directVolume = 0.0;
};
if (_isCrewAttenuate) then {
    _speakingType = "i";
    _directVolume = 1;
};
_canUnderstand = [_unit] call FUNC(canUnderstand);
private _params = [_speakingType, _id, !_canUnderstand, _directVolume^3, _emitterPos, _emitterDir];
TRACE_1("SPEAKING UPDATE", _params);
_params
