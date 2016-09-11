/*
 * Author: ACRE2Team
 * Checks whether the provided unit has an ACRE radio in their inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Whether the unit or player has a radio <BOOLEAN>
 *
 * Example:
 * _hasRadio = [player] call acre_api_fnc_hasRadio;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_unit"];
private _ret = false;

{
    private _weapon = _x;
    _ret = [_weapon] call FUNC(isRadio);
    if(_ret) exitWith { };
} foreach ([_unit] call EFUNC(lib,getGear));

_ret
