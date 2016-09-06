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

params["_unit"];
private _ret = false;

if ((_unit in ACRE_PLAYER_VEHICLE_CREW) and {vehicle acre_player != acre_player}) then {
    _hasCVC = getNumber(configFile >> "CfgVehicles" >> typeOf (vehicle acre_player) >> "ACRE" >> "CVC" >> "hasCVC");
    if(_hasCVC == 1) then {
        _ret = true;
    };
};

_ret
