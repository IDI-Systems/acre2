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

params [["_unit",objNull]];
private _vehicle = vehicle _unit;

if (isNull _vehicle) exitWith {};

private _attenuation = 0;
if (_unit != _vehicle) then {
    private _effectType = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "attenuationEffectType");

    {
        if (_unit == (_vehicle turretUnit _x)) exitWith {
            private _config = [_vehicle, _x] call CBA_fnc_getTurret;

            if ((getNumber (_config >> "disableSoundAttenuation")) == 1) then {
                _effectType = "";
            } else {
                if (isText (_config >> "soundAttenuationTurret")) then {
                    _effectType = getText (_config >> "soundAttenuationTurret");
                };
            };
        };
    } forEach allTurrets [_vehicle, true];

    // CfgSoundEffects >> AttenuationsEffects
    private _value = HASH_GET(GVAR(attenuationCache), _effectType);
    if (isNil "_value") then {
        private _config = configFile >> "CfgSoundEffects" >> "AttenuationsEffects" >> _effectType >> "acreAttenuation";
        if (isNumber(_config)) then {
            _attenuation = getNumber (_config);
            HASH_SET(GVAR(attenuationCache), _effectType, _attenuation);
        } else {
            _attenuation = getNumber (configFile >> "CfgSoundEffects" >> "AttenuationsEffects" >> "acreDefaultAttenuation");
            HASH_SET(GVAR(attenuationCache), _effectType, _attenuation);
        };
    } else {
        _attenuation = _value;
    };

};

_attenuation;
