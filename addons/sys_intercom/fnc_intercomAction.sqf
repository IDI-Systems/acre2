/*
 * Author: ACRE2Team
 * Adds an action for accessing the intercom network of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomAction
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _type = typeOf _target;

// Exit if object has no intercom
private _intercomNames = _target getVariable [QGVAR(intercomNames), []];
if (_intercomNames isEqualTo []) exitWith {};

// Exit if class already initialized
if (_type in GVAR(initializedIntercom)) exitWith {};
GVAR(initializedIntercom) pushBack _type;

// Passenger actions
private _intercomAction = [
    QGVAR(intercomAction),
    format ["%1", localize LSTRING(intercom)],
    ICON_RADIO_CALL,
    {true},
    {
        private _intercomNames = _target getVariable [QGVAR(intercomNames), []];
        private _intercomAvailable = false;
        // Find if at least one intercom is available
        {
            _intercomAvailable = [_target, acre_player, _forEachIndex] call FUNC(isIntercomAvailable);
            if (!_intercomAvailable) then {
                _intercomAvailable = [_target, acre_player, _forEachIndex] call FUNC(isInLimitedPosition);
            };
            if (_intercomAvailable) exitWith {};
        } forEach _intercomNames;
        _intercomAvailable
    },
    {_this call FUNC(intercomChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;

[_type, 1, ["ACE_SelfActions"], _intercomAction] call ace_interact_menu_fnc_addActionToClass;
