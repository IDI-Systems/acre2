#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Changes the spatial mode of the active radio.
 *
 * Arguments:
 * 0: Spatial mode (-1 = left, 0 = center, 1 = right) <NUMBER>
 * 1: Radio ID <STRING> (default: ACRE_ACTIVE_RADIO)
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [0] call acre_sys_core_fnc_switchRadioEar
 *
 * Public: No
 */

params ["_ear", ["_radioId", ACRE_ACTIVE_RADIO, [""]]];

switch (_ear) do {
    case -1: {
        [localize LSTRING(switchRadioEarLeft), ICON_RADIO_CALL] call FUNC(displayNotification);
    };
    case 0: {
        [localize LSTRING(switchRadioEarBoth), ICON_RADIO_CALL] call FUNC(displayNotification);
    };
    case 1: {
        [localize LSTRING(switchRadioEarRight), ICON_RADIO_CALL] call FUNC(displayNotification);
    };
};
//[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _ear]] call EFUNC(sys_data,dataEvent);
[_radioId, "setSpatial", _ear] call EFUNC(sys_data,dataEvent);

true
