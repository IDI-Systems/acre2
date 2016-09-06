/*
 * Author: AUTHOR
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

private ["_Lfs", "_Ptx", "_Rp"];
params["_distance", "_f", "_mW", "_ratio"];

_Lfs = -27.55 + 20*log(_f) + 20*log(_distance);
_Ptx = 10 * (log ((_mW*_ratio)/1000)) + 30;
_Rp = _Ptx - _Lfs;
_Rp;
