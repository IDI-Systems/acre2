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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_gx1", "_gx2", "_d"];
params["_g", "_g1", "_g2", "_d1", "_d2"];

_gx1 = (_g - _g1);
if(_gx1 == 0) then { _gx1 = 0.0001; };
_gx2 = (_g2 - _g1);
if(_gx2 == 0) then { _gx2 = 0.0001; };
_d = _d1 + (_gx1/_gx2)*(_d2 - _d1);
_d
