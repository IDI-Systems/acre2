/*
 * Author: ACRE2Team
 * Handles the antenna indicator (bound to the A3 stance indicator).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_gui_fnc_antennaElevationDisplay
 *
 * Public: No
 */
 #include "script_component.hpp"

// Need to run this every frame. Otherwise there will be noticeable delays
[{
    if (EGVAR(sys_core,automaticAntennaDirection)) exitWith {};
    
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

    private _ctrl = _ctrlGroup controlsGroupCtrl 201;
    _ctrl ctrlSetText "\idi\acre\addons\sys_gui\data\ui\" + _antennaStance + ".paa";
}, 0, []] call CBA_fnc_addPerFrameHandler;
