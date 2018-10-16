#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using a vehicle rack radio
 *
 * Arguments:
 * 0: Vehicle with racks <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: unique rack ID <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [vehicle acre_player, "", ["acre_vrc103_id_1"]] call acre_sys_rack_fnc_rackChildrenActions
 *
 * Public: No
 */

params ["_target", "_unit", "_params"];
_params params ["_rackClassName"];

private _actions = [];

/* Stashed Radio */
private _mountedRadio = [_rackClassName] call FUNC(getMountedRadio);

if ([_rackClassName, _unit] call FUNC(isRackAccessible)) then {
    if (_mountedRadio == "") then { // Empty
        if ([_rackClassName] call FUNC(isRadioRemovable)) then {
            private _action = [
                QGVAR(mountRadio),
                localize LSTRING(mountRadio),
                QPATHTOEF(ace_interact,data\icons\connector4.paa),
                {true},
                {true},
                {_this call FUNC(generateMountableRadioActions)},
                _params
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    } else {
        private _class = configFile >> "CfgWeapons" >> _mountedRadio;
        private _currentChannel = [_mountedRadio] call EFUNC(api,getRadioChannel);
        private _displayName = format [localize ELSTRING(ace_interact,channelShort), getText (_class >> "displayName"), _currentChannel];
        private _icon = getText (_class >> "picture");

        // General radio
        private _action = [
            QGVAR(mountedRadio),
            _displayName,
            _icon,
            {[_this#2#1] call EFUNC(sys_radio,openRadio)},
            {true},
            {
                _this#2 params ["_rackClassName", "_mountedRadio"];

                // Mounting options
                if ([_rackClassName] call FUNC(isRadioRemovable)) then {
                    // Unmount
                    private _action = [
                        QGVAR(unmount),
                        localize LSTRING(unmountRadio),
                        "",
                        {[_this#2, _this#1] call FUNC(unmountRadio)},
                        {true},
                        {},
                        _rackClassName
                    ] call ace_interact_menu_fnc_createAction;
                    [[_action, [], _target]]
                } else {
                    // Unmountable
                    private _action = [
                        QGVAR(unmountable),
                        localize LSTRING(unmountable),
                        "",
                        {true},
                        {true}
                    ] call ace_interact_menu_fnc_createAction;
                    [[_action, [], _target]]
                };
            },
            [_rackClassName, _mountedRadio]
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        // Using options
        if (_mountedRadio in ACRE_ACCESSIBLE_RACK_RADIOS || {_mountedRadio in ACRE_HEARABLE_RACK_RADIOS}) then {
            // Stop
            private _action = [
                QGVAR(stopUsingMountedRadio),
                localize LSTRING(stopUsingRadio),
                "",
                {_this call FUNC(stopUsingMountedRadio)},
                {true},
                {},
                _mountedRadio
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];

            private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
            private _radioActions = [
                _target,
                _unit,
                [_mountedRadio, _mountedRadio isEqualTo ACRE_ACTIVE_RADIO, _pttAssign]
            ] call EFUNC(ace_interact,radioChildrenActions);
            _actions append _radioActions;
        } else {
            // Use
            private _action = [
                QGVAR(useMountedRadio),
                localize LSTRING(useRadio),
                "",
                {_this call FUNC(startUsingMountedRadio)},
                {true},
                {},
                _mountedRadio
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    };
} else {
    if (_mountedRadio != "") then {
        if ([_rackClassName, _unit] call FUNC(isRackHearable)) then {
            // Radio type
            private _class = configFile >> "CfgWeapons" >> _mountedRadio;
            private _currentChannel = [_mountedRadio] call EFUNC(api,getRadioChannel);
            private _displayName = format [localize ELSTRING(ace_interact,channelShort), getText (_class >> "displayName"), _currentChannel];
            private _icon = getText (_class >> "picture");

            // General radio
            private _action = [
                QGVAR(mountedRadio),
                _displayName,
                _icon,
                {true},
                {true}
            ] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];

            // Check as well if a unit has the radio already in use (turned out/in etc)
            if (_mountedRadio in ACRE_HEARABLE_RACK_RADIOS || {_mountedRadio in ACRE_ACCESSIBLE_RACK_RADIOS}) then {
                private _action = [
                    QGVAR(stopUsingMountedRadio),
                    localize LSTRING(stopUsingRadio),
                    "",
                    {_this call FUNC(stopUsingMountedRadio)},
                    {true},
                    {},
                    _mountedRadio
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            } else {
                private _action = [
                    QGVAR(useMountedRadio),
                    localize LSTRING(useRadio),
                    "",
                    {_this call FUNC(startUsingMountedRadio)},
                    {true},
                    {},
                    _mountedRadio
                ] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };
    };
};

/* Connectors */
if (EGVAR(ace_interact,connectorsEnabled)) then {
    private _action = [
        "acre_connectors",
        "Connectors",
        QPATHTOEF(ace_interact,data\icons\connector4.paa),
        {true},
        {true},
        {_this call EFUNC(ace_interact,generateConnectors)}
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
