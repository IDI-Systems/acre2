#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handle showing and hiding Vehicle Info UI based on accessible systems of the current vehicle position.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, vehicle player] call acre_sys_gui_fnc_enterVehicle
 *
 * Public: No
 */

params ["_player", "_newVehicle"];

if (!isNull objectParent _player) then {
    // Open vehicle info display when racks are initialised
    [{(_this select 1) getVariable [QEGVAR(sys_rack,initialized), false]}, {
        params ["_player", "_vehicle"];
        private _numAccessibleRacks = [_vehicle, _player] call EFUNC(sys_rack,getAccessibleVehicleRacks);
        private _numIntercoms = 0;
        {
            if ([_vehicle, _player, _forEachIndex] call EFUNC(sys_intercom,isIntercomAvailable)) then {
                _numIntercoms = _numIntercoms + 1;
            };
        } forEach (_vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []]);

        // We do not check for hearable racks since none would appear if no intercoms are present
        if (!(_numAccessibleRacks isEqualTo []) || {_numIntercoms > 0}) then {
            (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(vehicleInfo), "PLAIN", 0, false];
        } else {
            // No intercom nor rack system is available. Do not show anything.
            (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        };
    }, [acre_player, _newVehicle], 5, {}] call CBA_fnc_waitUntilAndExecute;
} else {
    // Close vehicle info display
    (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
