#include "script_component.hpp"
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

// Macro instead of func for performance (may be run each frame)
#define FNC_SETANTENNAELEVATIONTEXT(theText) \
    private _ctrl = uiNamespace getVariable [ARR_2("ACRE_AntennaElevationInfo",controlNull)]; \
    if (!isNull _ctrl) then { _ctrl ctrlSetText theText; };


// Need to run this every frame. Otherwise there will be noticeable delays
[{
    // Collect data from stance
    private _stance = tolower (stance acre_player);

    // Hide antenna display if not applicable (in vehicle or other invalid stance or no radio)
    if (_stance == "" || {_stance == "undefined"} || {ACRE_ACTIVE_RADIO == ""}) exitWith {
        FNC_SETANTENNAELEVATIONTEXT("");
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
    FNC_SETANTENNAELEVATIONTEXT(("\idi\acre\addons\sys_gui\data\ui\" + _antennaStance + ".paa"));
}, 0, []] call CBA_fnc_addPerFrameHandler;
