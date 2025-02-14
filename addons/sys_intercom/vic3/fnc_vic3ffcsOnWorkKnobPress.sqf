#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the work knob.
 *
 * Arguments:
 * 0: 0: IDC <NUMBER> (unused)
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [idc, 0] call acre_sys_intercom_fnc_vic3ffcsOnWorkKnobPress
 *
 * Public: No
 */

params ["", "_key"];

private _currentDirection = -1;
if (_key == 0) then {
    // Left click
    _currentDirection = 1;
};

private _vehicle = vehicle acre_player;
private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);
private _newWorkPos = ((_workPos + _currentDirection) max 0) min VIC3FFCS_WORK_KNOB_POSITIONS;
private _success = [GVAR(activeIntercom), _newWorkPos] call FUNC(vic3ffcsSetWork);

if (!_success) exitWith {};

[MAIN_DISPLAY, _vehicle] call FUNC(vic3ffcsRender);
