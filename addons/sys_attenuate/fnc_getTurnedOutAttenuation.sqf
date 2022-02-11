#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the attenuation between players turned out and inside.
 *
 * Arguments:
 * 0: Unit <Object>
 *
 * Return Value:
 * Attenuation between players turned out and inside. <NUMBER>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_getTurnedOutAttenuation
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _turnedOutAttenuation = 0;

private _effectType = [_unit] call FUNC(getAttenuationEffectType);
if (_effectType isEqualTo "") exitWith {_turnedOutAttenuation};

private _cachedAttenuation = HASH_GET(GVAR(turnedOutAttenuationCache), _effectType);
if (!isNil "_cachedAttenuation") exitWith {_cachedAttenuation};

private _attenuationsEffectsCfg = configFile >> "CfgSoundEffects" >> "AttenuationsEffects";

private _attenuationCfg = _attenuationsEffectsCfg >> _effectType >> "acreTurnedOutAttenuation";
if (isNumber (_attenuationCfg)) then {
    _turnedOutAttenuation = getNumber (_attenuationCfg);
} else {
    _turnedOutAttenuation = getNumber (_attenuationsEffectsCfg >> "acreDefaultTurnedOutAttenuation");
};

HASH_SET(GVAR(turnedOutAttenuationCache), _effectType, _turnedOutAttenuation);

_turnedOutAttenuation
