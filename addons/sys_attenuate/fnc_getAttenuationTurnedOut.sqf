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
 * [unit] call acre_sys_attenuate_fnc_getAttenuationTurnedOut
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _attenuationTurnedOut = 0;

private _effectType = [_unit] call FUNC(getAttenuationEffectType);
if (_effectType isEqualTo "") exitWith {_attenuationTurnedOut};

private _cachedAttenuation = HASH_GET(GVAR(attenuationTurnedOutCache), _effectType);
if (!isNil "_cachedAttenuation") exitWith {_cachedAttenuation};

private _attenuationsEffectsCfg = configFile >> "CfgSoundEffects" >> "AttenuationsEffects";

private _attenuationCfg = _attenuationsEffectsCfg >> _effectType >> "acreAttenuationTurnedOut";
if (isNumber (_attenuationCfg)) then {
    _attenuationTurnedOut = getNumber (_attenuationCfg);
} else {
    _attenuationTurnedOut = getNumber (_attenuationsEffectsCfg >> "acreDefaultAttenuationTurnedOut");
};

HASH_SET(GVAR(attenuationTurnedOutCache), _effectType, _attenuationTurnedOut);

_attenuationTurnedOut
