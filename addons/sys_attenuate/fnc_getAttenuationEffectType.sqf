#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the attenuation effect type for the vehicle of the given unit.
 *
 * Arguments:
 * 0: Unit <Object>
 *
 * Return Value:
 * Attenuation effect type (see CfgSoundEffects >> AttenuationsEffects) or empty string if not available. <STRING>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_getAttenuationEffectType
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _vehicle = vehicle _unit;
if (isNull _vehicle) exitWith {""};

private _effectType = getText (configOf _vehicle >> "attenuationEffectType");

private _turret = _vehicle unitTurret _unit;
if (_turret in [[], [-1]]) exitWith {_effectType};

private _config = [_vehicle, _turret] call CBA_fnc_getTurret;

if ((getNumber (_config >> "disableSoundAttenuation")) isEqualTo 1) exitWith {""};

if (isText (_config >> "soundAttenuationTurret")) then {
    _effectType = getText (_config >> "soundAttenuationTurret");
};

_effectType
