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
    params ["_player"];

    if (!isNull objectParent _player) then {
        // Open vehicle info display
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(vehicleInfo), "PLAIN", 0, false];
        (QGVAR(antennaElevationInfo) call BIS_fnc_rscLayer) cutRsc ["", "PLAIN"];

    } else {
        // Close vehicle info display
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        (QGVAR(antennaElevationInfo) call BIS_fnc_rscLayer) cutRsc [QGVAR(antennaElevationInfo), "PLAIN", 0, false];
    };
};

DFUNC(antennaElevationDisplay) = {
    if (EGVAR(sys_core,automaticAntennaDirection)) exitWith {}; //TODO: Remove Display
    
    // Collect data from stance and antenna direction
    private _stance = tolower (stance acre_player);
    if (_stance == "" || _stance == "undefined") exitWith {};
    private _antennaDirection = "_straight";
    if (acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false]) then {
        _antennaDirection = "_bend";
    };

    // Check old antenna stance against new one
    private _antennaStance = _stance + _antennaDirection;
    if (GVAR(stanceCache) == _antennaStance) exitWith {};
    GVAR(stanceCache) = _antennaStance;

    // Change antenna icon to stance
    private _ctrlGroup = uiNamespace getVariable ["ACRE_AntennaElevationInfo", controlNull];
    if (isNull _ctrlGroup) exitWith {};

    private _ctrlBackground = _ctrlGroup controlsGroupCtrl 1;
    _ctrlBackground ctrlSetText "\idi\acre\addons\sys_gui\data\ui\" + _antennaStance + ".paa";
};

// Need to run this every frame. Otherwise there will be noticeable delays
[FUNC(antennaElevationDisplay), 0, []] call cba_fnc_addPerFrameHandler;

// Show display when entering vehicle
["vehicle", {
    params ["_player"];
    [_player] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;

// Show display at the very begining
[acre_player] call FUNC(enterVehicle);
