#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns if an individual racked radio is accessible to a specific unit.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1", acre_player] call acre_sys_rack_fnc_isRadioAccessible;
 *
 * Public: No
 */

params ["_radioId", "_unit"];

private _isAccessible = false;
private _rackId = [_radioId] call FUNC(getRackFromRadio);

if (_rackId != "") then {
    private _vehicle = [_rackId] call FUNC(getVehicleFromRack);
    _isAccessible = [_rackId, _unit, _vehicle] call FUNC(isRackAccessible);
};

_isAccessible
