/*
 * Author: ACRE2Team
 * Generates a list of actions for using vehicle intercoms externally
 *
 * Arguments:
 * 0: Unit with an intercom action <OBJECT>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_ace_interact_externalIntercomListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _actions = [];
private "_action";

private _vehicleIntercom = acre_player getVariable ["vehicleIntercom", nil];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the intercom's telephone can be given
    if (!isNil "_vehicleIntercom") then {
        // Generate the action to give the intercom
        _action = ["acre_give_externalIntercom", localize LSTRING(giveIntercom), "", {[acre_player getVariable ["vehicleIntercom", nil], _target, 2, acre_player] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    // Pointing at a vehicle. Get or return the intercom
    if (isNil "_vehicleIntercom") then {

        private _intercomUnit = _target getVariable ["intercomUnit", acre_player];
        if (acre_player == _intercomUnit) then {
            // Generate the action to take the intercom's telephone
            _action = ["acre_take_externalIntercom", localize LSTRING(takeIntercom), "", {[_target, acre_player, 1] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    } else {
        if (_vehicleIntercom == _target) then {
            // Generate the action to return the intercom's telephone
            _action = ["acre_return_externalIntercom", localize LSTRING(returnIntercom), "", {[_target, acre_player, 0] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    };
};

_actions
