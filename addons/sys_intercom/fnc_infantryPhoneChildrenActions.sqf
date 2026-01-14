#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using vehicle intercoms externally.
 *
 * Arguments:
 * 0: Vehicle/Unit target of interaction <OBJECT>
 * 1: Unit interacting with target <OBJECT>
 * 2: Relative position of the infantry phone interaction on the vehicle <POSITION> (default: [0, 0, 0])
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_infantryPhoneChildrenActions
 *
 * Public: No
 */

params ["_target", "_unit", "_position"];

private _actions = [];

(acre_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, INTERCOM_DISCONNECTED]]) params ["_vehicleInfantryPhone", "_infantryPhoneNetwork"];
(_target getVariable [QGVAR(unitInfantryPhone), [objNull, INTERCOM_DISCONNECTED]]) params ["_unitInfantryPhone", "_unitInfantryPhoneNetwork"];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the infantry telephone can be given
    if (!isNull _vehicleInfantryPhone) then {
        // Generate the action to give the intercom
        private _action = [
            QGVAR(giveInfantryPhone),
            LLSTRING(giveInfantryPhone),
            QPATHTOEF(ace_interact,data\icons\give_phone.paa),
            {
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];

                //USES_VARIABLES ["_target", "_player"];
                [_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, INTERCOM_DISCONNECTED]] select 0, _target, 2, _intercomNetwork, _player, [-1]] call FUNC(updateInfantryPhoneStatus)
            },
            {true},
            {},
            _infantryPhoneNetwork
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    if (vehicle acre_player != _target) then {
        // Pointing at a vehicle. Get or return the infantry telephone
        if (isNull _vehicleInfantryPhone && (isNull _unitInfantryPhone)) then {
            {
                private _action = [
                    format [QGVAR(takeInfantryPhone_%1), _x],
                    format [LLSTRING(takeInfantryPhone), format ["(%1)", (_intercomNames select _forEachIndex) select 2]],
                    QPATHTOEF(ace_interact,data\icons\phone.paa),
                    {
                        params ["_target", "_player", "_params"];
                        _params params ["_intercomNetwork", "_position"];
                        [_target, _player, 1, _intercomNetwork, objNull, _position] call FUNC(updateInfantryPhoneStatus);
                    },
                    {
                        params ["_target", "_player", "_params"];
                        _params params ["_intercomNetwork"];
                        private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), [false, INTERCOM_DISCONNECTED]];
                        !(_isCalling select 0) || ((_isCalling select 0) && ((_isCalling select 1) == _intercomNetwork))
                    },
                    {},
                    [_forEachIndex, _position]
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            } forEach (_intercomNames select {_x in (_target getVariable [QGVAR(infantryPhoneIntercom), []])});
        } else {
            if (_vehicleInfantryPhone == _target) then {
                // Generate the action to return the infantry telephone
                private _action = [
                    QGVAR(returnInfantryPhone),
                    LLSTRING(returnInfantryPhone),
                    QPATHTOEF(ace_interact,data\icons\return_phone.paa),
                    {
                        params ["_target", "_player", ""];
                        //USES_VARIABLES ["_target", "_player"];
                        [_target, _player, 0, INTERCOM_DISCONNECTED] call FUNC(updateInfantryPhoneStatus);
                    },
                    {true},
                    {},
                    {}
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];

                // Generate actions to switch intercom
                {
                    _action = [
                        format [QGVAR(switchInfantryPhone_%1), _x],
                        format [LLSTRING(switchInfantryPhone), format ["(%1)", (_intercomNames select _forEachIndex) select 2]],
                        QPATHTOEF(ace_interact,data\icons\phone.paa),
                        {
                            params ["_target", "_player", "_params"];
                            _params params ["_intercomNetwork"];
                            //USES_VARIABLES ["_target", "_player"];
                            [_target, _player, 3, _intercomNetwork] call FUNC(updateInfantryPhoneStatus)
                        },
                        {
                            params ["_target", "_player", "_params"];
                            _params params ["_intercomNetwork", "_infantryPhoneNetwork"];

                            // Only show not connected intercom networks
                            _infantryPhoneNetwork != _intercomNetwork
                        },
                        {},
                        [_forEachIndex, _infantryPhoneNetwork]
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                } forEach (_intercomNames select {_x in (_target getVariable [QGVAR(infantryPhoneIntercom), []])});
            } else {
                // Generate empty action to show that the infantry phone is being used by someone else
                private _action = [
                    QGVAR(infantryPhoneUnavailable),
                    LLSTRING(infantryPhoneUnavailable),
                    QPATHTOEF(ace_interact,data\icons\return_phone.paa),
                    {true},
                    {true},
                    {},
                    {}
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };
    } else {
        // Player is inside the vehicle.
        private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), [false, INTERCOM_DISCONNECTED]];

        if (_isCalling select 0) then {
            private _action = [
                QGVAR(infantryPhoneStopCalling),
                LLSTRING(infantryPhone_stopCalling),
                QPATHTOEF(ace_interact,data\icons\stop_phone_call.paa),
                {
                    params ["_target", "", "_params"];
                    _params params ["_intercomNetwork"];

                    _target setVariable [QGVAR(isInfantryPhoneCalling), [false, _intercomNetwork], true];},
                {true},
                {},
                _isCalling select 1
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        } else {
            if (isNull _vehicleInfantryPhone) then {
                {
                    private _action = [
                        format [QGVAR(infantryPhoneStartCalling_%1), _x],
                        format [LLSTRING(infantryPhone_startCalling), format["(%1)", (_intercomNames select _forEachIndex) select 2]],
                        QPATHTOEF(ace_interact,data\icons\phone_call.paa),
                        {
                             params ["_target", "", "_params"];
                            _params params ["_intercomNetwork"];

                            [_target, _intercomNetwork] call FUNC(infantryPhoneSoundCall)},
                        {true},
                        {},
                        _isCalling select 1
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                } forEach (_intercomNames select {_x in (_target getVariable [QGVAR(infantryPhoneIntercom), []])});
            };
        };
    };
};

_actions
