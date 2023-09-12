#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc148_fnc_setOnOffState
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "_radioData"];

HASH_SET(_radioData, "radioOn", _eventData);
if (_radioId == EGVAR(sys_radio,currentRadioDialog)) then {
    if (_eventData == 0) then {
        //acre_player sideChat "RADIO OFF!";
        HASH_SET(_radioData, "currentState", "OffDisplay");
        HASH_SET(_radioData, "menuPage", 0);
        HASH_SET(_radioData, "menuIndex", 0);
        HASH_SET(_radioData, "entryCursor", 0);
        HASH_SET(_radioData, "selectedEntry", 0);
    } else {
        if (_eventData == 0.5) then {
            //acre_player sideChat "RADIO ON!";
            HASH_SET(_radioData, "currentState", "PostScreen");
            HASH_SET(_radioData, "menuPage", 0);
            HASH_SET(_radioData, "menuIndex", 0);
            HASH_SET(_radioData, "entryCursor", 0);
            HASH_SET(_radioData, "selectedEntry", 0);
        };
    };
    private _display = uiNamespace getVariable QGVAR(currentDisplay);
    [_display] call FUNC(render);
};
