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

private _fnc_setAntennaElevationText = {
    private _ctrlGroup = uiNamespace getVariable ["ACRE_AntennaElevationInfo", controlNull];
    if (isNull _ctrlGroup) exitWith {};

    params ["_text"];
    private _ctrl = _ctrlGroup controlsGroupCtrl 201;
    _ctrl ctrlSetText _text;
};

// Need to run this every frame. Otherwise there will be noticeable delays
[{
    params ["_args"];
    _args params ["_fnc_setAntennaElevationText"];

    // Collect data from stance
    private _stance = tolower (stance acre_player);

    // Hide antenna display if not applicable (in vehicle or other invalid stance or no radio)
    if (_stance == "" || {_stance == "undefined"} || {ACRE_ACTIVE_RADIO == ""}) exitWith {
        [""] call _fnc_setAntennaElevationText;
        GVAR(stanceCache) = "";
    };

    // Collect data from antenna direction
    private _antennaDirection = "_straight";
    if (acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false] || {EGVAR(sys_core,automaticAntennaDirection) && {_stance != "stand"}}) then {
        _antennaDirection = "_bend";
    };

    // Check old antenna stance against new one
    private _antennaStance = _stance + _antennaDirection;
    if (GVAR(stanceCache) == _antennaStance) exitWith {};
    GVAR(stanceCache) = _antennaStance;

    // Change antenna icon to stance
    ["\idi\acre\addons\sys_gui\data\ui\" + _antennaStance + ".paa"] call _fnc_setAntennaElevationText;
}, 0, [_fnc_setAntennaElevationText]] call CBA_fnc_addPerFrameHandler;
