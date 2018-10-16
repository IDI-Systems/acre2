#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns if an individual racked radio is hearable (in intercom) to a specific unit.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1", acre_player] call acre_sys_rack_fnc_isRadioHearable;
 *
 * Public: No
 */

params ["_radioId", "_unit"];

private _isHearable = false;
private _rackId = [_radioId] call FUNC(getRackFromRadio);

if (_rackId != "") then {
    private _vehicle = [_rackId] call FUNC(getVehicleFromRack);
    _isHearable = [_rackId, _unit, _vehicle] call FUNC(isRackHearable);
};

_isHearable
