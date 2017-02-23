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

private _vehicleInfantryPhone = acre_player getVariable [QGVAR(vehicleInfantryPhone), objNull];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the infantry telelphone can be given
    if (!isNull _vehicleInfantryPhone) then {
        // Generate the action to give the intercom
        private _action = ["acre_give_infantryTelephone", localize LSTRING(giveInfantryPhone), "", {[_player getVariable [QGVAR(vehicleInfantryPhone), nil], _target, 2, _player] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    if (vehicle acre_player != _target) then {
        // Pointing at a vehicle. Get or return the infantry telelphone
        if (isNull _vehicleInfantryPhone) then {
            private _unitInfantryPhone = _target getVariable [QGVAR(unitInfantryPhone), acre_player];
            if (acre_player == _unitInfantryPhone) then {
                // Generate the action to take the infantry telelphone
                private _action = ["acre_take_infantryTelephone", localize LSTRING(takeInfantryPhone), "", {[_target, _player, 1] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        } else {
            if (_vehicleInfantryPhone == _target) then {
                // Generate the action to return the infantry telephone
                private _action = ["acre_return_infantryTelephone", localize LSTRING(returnInfantryPhone), "", {[_target, _player, 0] call EFUNC(sys_core,updateInfantryPhoneStatus)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };
    } else {
        // Player is inside the vehicle.
        private _isCalling = _vehicle getVariable [QGVAR(isInfantryPhoneCalling), false];
        if (_isCalling) then {
            private _action = ["acre_infantryTelephone_stopCalling", localize LSTRING(infantryPhone_stopCalling), "", {_target setVariable [QGVAR(isInfantryPhoneCalling), false, true];}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
        } else {
            private _action = ["acre_infantryTelephone_startCalling", localize LSTRING(infantryPhone_startCalling), "", {[_target] call FUNC(infantryPhoneSoundCall)}, {true}, {}, {}] call ace_interact_menu_fnc_createAction;
        };
        _actions pushBack [_action, [], _target];
    };
};

_actions
