#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the configuration (No use, TX Ony, RX only or TX/RX) for the given unit of a rack that is connected to intercom. This function
 * gives back the maximum RX/TX capability of a rack in case several intercoms are connected to the same rack;
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Vehicle where the radio rack is <OBJECT>
 * 2: Unit <OBJECT>
 * 3: Unique rack ID <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * Radio functionality: -1 (Rack disabled), 0 (Not Monitoring), 1 (Receive only), 2 (Transmit only) and 3 (Receive and Transmit) <NUMBER>
 *
 * Example:
 * ["acre_vrc110_id_1", vehicle acre_player, acre_player] call acre_sys_intercom_fnc_getRackRxTxCapabilities
 *
 * Public: No
 */

params ["_radioId", "_vehicle", "_unit", ["_rackId", ""]];

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

private _functionality = RACK_DISABLED;

{
    private _wiredRacks = [_vehicle, _unit, _forEachIndex, "wiredRacks"] call FUNC(getStationConfiguration);
    {
        params ["_rack", "_func"];
        // Only increase the functionality if it is greater (RACK_DISABLED < RACK_NO_MONITOR < RACK_RX_ONLY < RACK_TX_ONLY < RACK_RX_AND_TX)
        if ((_rack == _rackId) && {_func > _functionality}) exitWith {
            _functionality = _func;
        };
    } forEach _wiredRacks;
} forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

_functionality
