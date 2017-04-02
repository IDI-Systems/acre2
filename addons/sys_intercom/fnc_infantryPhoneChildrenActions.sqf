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
 * [cursorTarget] call acre_sys_intercom_infantryPhoneChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _actions = [];

(acre_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, NO_INTERCOM]]) params ["_vehicleInfantryPhone", "_infantryPhoneNetwork"];

if (_target isKindOf "CAManBase") then {
    // Pointing at an infantry unit. Check if the infantry telelphone can be given
    if (!isNull _vehicleInfantryPhone) then {
        // Generate the action to give the intercom
        private _action = [
            "acre_give_infantryTelephone",
            localize LSTRING(giveInfantryPhone),
            "",
            {[_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, NO_INTERCOM]] select 0, _target, 2, _infantryPhoneNetwork, _player] call FUNC(updateInfantryPhoneStatus)},
            {true},
            {},
            {}
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    if (vehicle acre_player != _target) then {
        _infantryPhoneIntercom = _target getVariable [QGVAR(infantryPhoneIntercom), []];

        // Pointing at a vehicle. Get or return the infantry telelphone
        if (isNull _vehicleInfantryPhone) then {
            (_target getVariable [QGVAR(unitInfantryPhone), [acre_player, NO_INTERCOM]]) params ["_unitInfantryPhone", ""];
            if (acre_player == _unitInfantryPhone) then {
                // Generate the action to take the infantry telephone
                if ("crew" in _infantryPhoneIntercom) then {
                    private _action = [
                        "acre_take_infantryTelephoneCrew",
                        format [localize LSTRING(takeInfantryPhone), "(" + localize CREW_STRING] + ")",
                        "",
                        {[_target, _player, 1, CREW_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {true},
                        {},
                        {}
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                };

                //  Do not allow to pick up the interphone and connect to passenger intercom if the crew is calling
                private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), false];
                if ("passenger" in _infantryPhoneIntercom && !_isCalling) then {
                    private _action = [
                        "acre_take_infantryTelephoneCrew",
                        format [localize LSTRING(takeInfantryPhone), "(" + localize LSTRING(passenger) + ")"],
                        "",
                        {[_target, _player, 1, PASSENGER_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {true},
                        {},
                        {}
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                };
            };
        } else {
            if (_vehicleInfantryPhone == _target) then {
                // Generate the action to return the infantry telephone
                if (_infantryPhoneNetwork == CREW_INTERCOM) then {
                    private _action = [
                        "acre_switch_infantryTelephonePassenger",
                        format [localize LSTRING(switchInfantryPhone), "(" + localize LSTRING(passenger) + ")"],
                        "",
                        {[_target, _player, 3, PASSENGER_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {!((_target getVariable [QGVAR(passengerIntercomPositions), []]) isEqualTo [])},  // This should only be available if the vehicle has passenger intercom
                        {},
                        {}
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                    _action = [
                        "acre_return_infantryTelephoneCrew",
                        localize LSTRING(returnInfantryPhone),
                        "",
                        {[_target, _player, 0, CREW_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {true}, {}, {}] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                };

                if (_infantryPhoneNetwork == PASSENGER_INTERCOM) then {
                    private _action = [
                        "acre_switch_infantryTelephoneCrew",
                        format [localize LSTRING(switchInfantryPhone), "(" + localize CREW_STRING] + ")",
                        "",
                        {[_target, _player, 3, CREW_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {true},
                        {},
                        {}
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                    _action = [
                        "acre_return_infantryTelephoneCrew",
                        localize LSTRING(returnInfantryPhone),
                        "",
                        {[_target, _player, 0, PASSENGER_INTERCOM] call FUNC(updateInfantryPhoneStatus)},
                        {true},
                        {},
                        {}
                    ] call ace_interact_menu_fnc_createAction;
                    _actions pushBack [_action, [], _target];
                };
            };
        };
    } else {
        // Player is inside the vehicle.
        private _isCalling = _target getVariable [QGVAR(isInfantryPhoneCalling), false];
        if (_isCalling) then {
            private _action = [
                "acre_infantryTelephone_stopCalling",
                localize LSTRING(infantryPhone_stopCalling),
                "",
                {_target setVariable [QGVAR(isInfantryPhoneCalling), false, true];},
                {true},
                {},
                {}
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        } else {
            if (isNull _vehicleInfantryPhone) then {
                private _action = [
                    "acre_infantryTelephone_startCalling",
                    localize LSTRING(infantryPhone_startCalling),
                    "",
                    {[_target] call FUNC(infantryPhoneSoundCall)},
                    {true},
                    {},
                    {}
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };
    };
};

_actions
