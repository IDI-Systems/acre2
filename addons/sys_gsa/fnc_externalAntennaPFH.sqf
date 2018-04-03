/*
 * Author: ACRE2Team
 * Eventhandler to monitor if external radios can be still used by a specific player.
 *
 * - Disabled uses of external radios are:
 *   - Antenna is destroyed.
 *   - Distance between the antenna and the player 10m.
 *   - Antenna is picked up.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_gsa_externalAntennaPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_gsa"];

if (!alive _gsa) then {
    [acre_player, _gsa] call FUNC(disconnect);
} else {
    private _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];

    if (_radioId != "") then {
        // Check if this is a rack radio
        private _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
        private _unit = objNull;
        if (_rackId != "") then {
            _unit = [_rackId] call EFUNC(sys_rack,getVehicleFromRack);
        } else {
            if ([_radioId] call EFUNC(sys_external,isExternalRadioUsed)) then {
                _unit = [_radioId] call EFUNC(sys_external,getExternalRadioOwner);
            } else {
                _unit = acre_player;
            };
        };

        if ((_unit distance _gsa) > ANTENNA_MAXDISTANCE) then {
            [acre_player, _gsa] call FUNC(disconnect);
        };
    };
};
