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
 * [cursorTarget] call acre_ace_interact_infantryPhoneChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];


private _actions = [];
private "_action";

private _vehicleInfantryPhone = acre_player getVariable ["vehicleInfantryPhone", nil];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the infantry telelphone can be given
    if (!isNil "_vehicleInfantryPhone") then {
        // Generate the action to give the intercom
        _action = ["acre_give_infantryTelephone", localize LSTRING(giveInfantryTelephone), "", {[acre_player getVariable ["vehicleInfantryPhone", nil], _target, 2, acre_player] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    // Pointing at a vehicle. Get or return the infantry telelphone
    if (isNil "_vehicleInfantryPhone") then {
        private _unitInfantryPhone = _target getVariable ["unitInfantryPhone", acre_player];
        if (acre_player == _unitInfantryPhone) then {
            // Generate the action to take the infantry telelphone
            _action = ["acre_take_infantryTelephone", localize LSTRING(takeInfantryTelephone), "", {[_target, acre_player, 1] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    } else {
        if (_vehicleInfantryPhone == _target) then {
            // Generate the action to return the infantry telelphone
            _action = ["acre_return_infantryTelephone", localize LSTRING(returnInfantryTelephone), "", {[_target, acre_player, 0] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    };
};

_actions
