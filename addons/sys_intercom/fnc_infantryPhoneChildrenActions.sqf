#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using vehicle intercoms externally.
 *
 * Arguments:
 * 0: Vehicle/Unit <OBJECT>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_infantryPhoneChildrenActions
 *
 * Public: No
 */

params ["_target"];

private _actions = [];

(acre_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, INTERCOM_DISCONNECTED]]) params ["_vehicleInfantryPhone", "_infantryPhoneNetwork"];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the infantry telelphone can be given
    if (!isNull _vehicleInfantryPhone) then {
        // Generate the action to give the intercom
        private _action = [
            QGVAR(giveInfantryPhone),
            localize LSTRING(giveInfantryPhone),
            "",
            {
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];

                //USES_VARIABLES ["_target", "_player"];
                [_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, INTERCOM_DISCONNECTED]] select 0, _target, 2, _intercomNetwork, _player] call FUNC(updateInfantryPhoneStatus)
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
        if (isNull _vehicleInfantryPhone) then {
            {
                private _action = [
                    format [QGVAR(takeInfantryPhone_%1), _x],
                    format [localize LSTRING(takeInfantryPhone), format ["(%1)", (_intercomNames select _forEachIndex) select 2]],
                    "",
                    {
                        params ["_target", "_player", "_params"];
                        _params params ["_intercomNetwork"];
                        [_target, _player, 1, _intercomNetwork] call FUNC(updateInfantryPhoneStatus)
                    },
                    {
                        params ["_target", "_player", "_params"];
                        _params params ["_intercomNetwork"];
                        private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), [false, INTERCOM_DISCONNECTED]];
                        !(_isCalling select 0) || ((_isCalling select 0) && ((_isCalling select 1) == _intercomNetwork))
                    },
                    {},
                    _forEachIndex
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            } forEach (_intercomNames select {_x in (_target getVariable [QGVAR(infantryPhoneIntercom), []])});
        } else {
            if (_vehicleInfantryPhone == _target) then {
                // Generate the action to return the infantry telephone
                private _action = [
                    QGVAR(returnInfantryPhone),
                    format [localize LSTRING(returnInfantryPhone)],
                    "",
                    {
                        params ["_target", "_player", ""];
                        //USES_VARIABLES ["_target", "_player"];
                        [_target, _player, 0, INTERCOM_DISCONNECTED] call FUNC(updateInfantryPhoneStatus)
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
                        format [localize LSTRING(switchInfantryPhone), format ["(%1)", (_intercomNames select _forEachIndex) select 2]],
                        "",
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
            };
        };
    } else {
        // Player is inside the vehicle.
        private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), [false, INTERCOM_DISCONNECTED]];

        if (_isCalling select 0) then {
            private _action = [
                QGVAR(infantryPhoneStopCalling),
                localize LSTRING(infantryPhone_stopCalling),
                "",
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
            if (isNull _vehicleInfantryPhone && {!(_target getVariable [QGVAR(infPhoneDisableRinging), false])}) then {
                {
                    private _action = [
                        format [QGVAR(infantryPhoneStartCalling_%1), _x],
                        format [localize LSTRING(infantryPhone_startCalling), format["(%1)", (_intercomNames select _forEachIndex) select 2]],
                        "",
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
