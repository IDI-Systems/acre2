#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the spatial radio configuration.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Spatial radio configuration <STRING>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioSpatial
 *
 * Public: No
 */

params ["_radio"];

private _side = "CENTER";

if (!(isNil "_radio")) then {
    private _isInitialized = [_radio] call EFUNC(sys_data,isRadioInitialized);
//    diag_log format["STATE WTF: %1=%2", _radio, _state];
    if (_isInitialized) then {
        private _spatial = [_radio, "getSpatial"] call EFUNC(sys_data,dataEvent);

        switch (_spatial) do {
            case -1: {
                _side = "LEFT";
            };
            case 1: {
                _side = "RIGHT";
            };
            case 0: {
                _side = "CENTER";
            };
            default {
                _side = "CENTER";
            };
        };
    };
};

_side
