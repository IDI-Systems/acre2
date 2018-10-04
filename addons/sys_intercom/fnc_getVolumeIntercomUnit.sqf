#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Get the volume of a unit in intercom. If a unit is transmitting simultaneously through multiple intercoms, the maximum volume is returned.
 *
 * Arguments:
 * 0: Unit to be evaluated <OBJECT>
 *
 * Return Value:
 * Maximum volume <NUMBER>
 *
 * Example:
 * [unit] call acre_sys_intercom_fnc_getVolumeIntercomUnit
 *
 * Public: No
 */

params ["_unit"];

// Return the maximum volume if a unit is connected to multiple intercoms
private _maxVolume = 0.0;

// Check if the player is infantry phone
private _vehicleInfantryPhone = (acre_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, 0]]) select 0;
if (isNull _vehicleInfantryPhone) then {
    // player is inside a vehicle and not using the infantry phone.
    {
        if (_unit in _x) then {
            private _volume = [vehicle acre_player, acre_player, _forEachIndex, 2] call FUNC(getStationConfiguration);
            if (_maxVolume < _volume) then {
                _maxVolume = _volume;
            };
        };
    } forEach ACRE_PLAYER_INTERCOM;
} else {
    _maxVolume = 1.0;
};

_maxVolume
