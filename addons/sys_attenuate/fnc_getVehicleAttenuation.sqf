#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the attenuation of a unit being heard externally from the vehicle.
 *
 * Arguments:
 * 0: Unit (or vehicle) <Object>
 *
 * Return Value:
 * Attenuation <NUMBER>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_getVehicleAttenuation
 *
 * Public: No
 */

params [["_unit",objNull]];
private _vehicle = vehicle _unit;

if (isNull _vehicle) exitWith {};

private _attenuation = 0;
private _effectType = getText (configOf _vehicle >> "attenuationEffectType");

private _turret = _vehicle unitTurret _unit;
if (!(_turret in [[], [-1]])) then {
    private _config = [_vehicle, _turret] call CBA_fnc_getTurret;

    if ((getNumber (_config >> "disableSoundAttenuation")) == 1) then {
        _effectType = "";
    } else {
        if (isText (_config >> "soundAttenuationTurret")) then {
            _effectType = getText (_config >> "soundAttenuationTurret");
        };
    };
};

if (_effectType != "") then {
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
