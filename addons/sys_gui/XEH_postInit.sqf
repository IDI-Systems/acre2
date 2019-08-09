#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (!hasInterface) exitWith {};

// Volume Control - keybind, unit change event, and scroll wheel EH
["ACRE2", "VolumeControl", localize LSTRING(VolumeControl),
    LINKFUNC(volumeKeyDown),
    LINKFUNC(volumeKeyUp),
[DIK_TAB, [false, false, false]], true] call CBA_fnc_addKeybind;

["unit", LINKFUNC(volumeKeyUp)] call CBA_fnc_addPlayerEventHandler;
["MouseZChanged", LINKFUNC(onMouseZChanged)] call CBA_fnc_addDisplayHandler;

[] call FUNC(antennaElevationDisplay);

// TODO - Look into this below.
acre_player addEventHandler ["Take", {call FUNC(handleTake)}];

DFUNC(enterVehicle) = {
    params ["_player", "_newVehicle"];

    if (!isNull objectParent _player) then {
        // Open vehicle info display when racks are initialised
        [{(_this select 1) getVariable [QEGVAR(sys_rack,initialized), false]}, {
            params ["_player", "_vehicle"];
            private _numAccessibleRacks = [_vehicle, _player] call EFUNC(sys_rack,getAccessibleVehicleRacks);
            private _numIntercoms = 0;
            {
                if ([_vehicle, _player, 0] call EFUNC(sys_intercom,isIntercomAvailable)) then {
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
};

// Show display when entering vehicle
["vehicle", {
    params ["_player", "_newVehicle"];
    [_player, _newVehicle] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;

// Hide display when entering a feature camera
["featureCamera", {
    params ["_player", "_featureCamera"];

    if (_featureCamera isEqualTo "") then {
        [_player, vehicle _player] call FUNC(enterVehicle);
    } else {
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    };
}, true] call CBA_fnc_addPlayerEventHandler;


// Fix Vehicle Info UI wrong saved values from: <=2.7.0 and Arma 3 v1.94 - remove in 2.9.0
// https://feedback.bistudio.com/T142860
// Only X, Y and W entries were breaking - set to 0 as a result of BIS_fnc_parseNumberSafe
private _vehicleInfoX = profileNamespace getVariable ["IGUI_grid_ACRE_vehicleInfo_X", 0];
private _vehicleInfoY = profileNamespace getVariable ["IGUI_grid_ACRE_vehicleInfo_Y", 0];
private _vehicleInfoW = profileNamespace getVariable ["IGUI_grid_ACRE_vehicleInfo_w", 0];
// Reset all (H for redundancy)
if (_vehicleInfoX == 0 && {_vehicleInfoY} && {_vehicleInfoW == 0}) then {
    profileNamespace setVariable ["IGUI_grid_ACRE_vehicleInfo_X", VEHICLE_INFO_DEFAULT_X];
    profileNamespace setVariable ["IGUI_grid_ACRE_vehicleInfo_Y", VEHICLE_INFO_DEFAULT_Y];
    profileNamespace setVariable ["IGUI_grid_ACRE_vehicleInfo_W", VEHICLE_INFO_DEFAULT_W];
    profileNamespace setVariable ["IGUI_grid_ACRE_vehicleInfo_H", VEHICLE_INFO_DEFAULT_H];
    INFO("Vehicle Info UI fixed (<=2.7.0 and Arma 3 v1.94 bug).");
};
