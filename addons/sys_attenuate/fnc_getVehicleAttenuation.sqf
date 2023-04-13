#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the attenuation of a unit being heard externally from the vehicle.
 *
 * Arguments:
 * 0: Unit <Object>
 *
 * Return Value:
 * Attenuation <NUMBER>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_getVehicleAttenuation
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _attenuation = 0;

private _effectType = [_unit] call FUNC(getAttenuationEffectType);
if (_effectType isEqualTo "") exitWith {_attenuation};

private _cachedAttenuation = HASH_GET(GVAR(attenuationCache), _effectType);
if (!isNil "_cachedAttenuation") exitWith {_cachedAttenuation};

private _attenuationsEffectsCfg = configFile >> "CfgSoundEffects" >> "AttenuationsEffects";

private _attenuationCfg = _attenuationsEffectsCfg >> _effectType >> "acreAttenuation";
if (isNumber (_attenuationCfg)) then {
    _attenuation = getNumber (_attenuationCfg);
} else {
    _attenuation = getNumber (_attenuationsEffectsCfg >> "acreDefaultAttenuation");
};

HASH_SET(GVAR(attenuationCache), _effectType, _attenuation);

_attenuation
