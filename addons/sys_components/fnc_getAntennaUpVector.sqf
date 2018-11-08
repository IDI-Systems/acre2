/*
 * Author: ACRE2Team
 * Calculates the upright direction depending on the Antenna Settings.
 *
 * Arguments:
 * 0: Object to calculate the antenna direction for <OBJECT>
 * 1: Upright direction in vector coordinates  <ARRAY>
 *
 * Return Value:
 * Corrected vector data for upright direction <ARRAY>
 *
 * Example:
 * [myPolarVector] call acre_sys_components_getAntennaUpVector
 *
 * Public: No
 */
#include "script_component.hpp"

params [
    "_obj",
    ["_upV", [0,0,0], [], 3]
];

if (EGVAR(sys_core,automaticAntennaDirection)) then {
    private _upP = _upV call cba_fnc_vect2polar;
    _upP set [2, ((_upP select 2) max 55) min 90];
    _upV = _upP call cba_fnc_polar2vect; 
} else {
    if (_obj getVariable [QEGVAR(sys_core,antennaDirUp), false]) then {
        private _upP = _upV call cba_fnc_vect2polar;
        _upP set [2, ((_upP select 2) + 50)];
        _upV = _upP call cba_fnc_polar2vect; 
    };
};

_upV
