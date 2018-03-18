#include "script_component.hpp"

if (!hasInterface) exitWith {};

[] call FUNC(enableZeusOverlay);

// TODO - Look into this below.
acre_player addEventHandler ["Take", {call FUNC(handleTake)}];

// Register volume control key handlers
["ACRE2", "VolumeControl", localize LSTRING(VolumeControl),
    FUNC(onVolumeControlKeyPress),
    FUNC(onVolumeControlKeyPressUp),
[15, [false, false, false]], true] call CBA_fnc_addKeybind;

["unit", FUNC(onVolumeControlKeyPressUp)] call CBA_fnc_addPlayerEventHandler;

DFUNC(enterVehicle) = {
    params ["_player", "_newVehicle"];

    if (!isNull objectParent _player) then {
        // Open vehicle info display
        private _numAccessibleRacks = [_newVehicle, _player] call EFUNC(sys_rack,getAccessibleVehicleRacks);
        private _numIntercoms = 0;
        {
            if ([_newVehicle, _player, 0] call EFUNC(sys_intercom,isIntercomAvailable)) then {
                _numIntercoms = _numIntercoms + 1;
            };
        } forEach (_newVehicle getVariable [QEGVAR(sys_intercom,intercomNames), []]);

        // We do not check for hearable racks since none would appear if no intercoms are present
        if (!(_numAccessibleRacks isEqualTo []) || {_numIntercoms > 0}) then {
            (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(vehicleInfo), "PLAIN", 0, false];
        } else {
            // No intercom nor rack system is available. Do not show anything.
            (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        };
    } else {
        // Close vehicle info display
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    };
};

// Show display when entering vehicle
["vehicle", {
    params ["_player", "_newVehicle"];

    [_player, _newVehicle] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;

// Show display at the very begining
[acre_player] call FUNC(enterVehicle);
