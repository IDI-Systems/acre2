/*
 * Author: ACRE2Team
 * Configures the interaction between racks and intercom systems.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_rack_fnc_configureRackIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _racks = [_vehicle] call FUNC(getVehicleRacks);
{
    private _intercoms = [_x] call FUNC(getWiredIntercoms);
    private _rackRxTxConfig = _vehicle getVariable [QGVAR(rackRxTxConfig), []];
    if (!(_intercoms isEqualTo []) && {_rackRxTxConfig isEqualTo []}) exitWith {
        [_vehicle] call EFUNC(sys_intercom,configRxTxCapabilities);
    };
} forEach _racks;
