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
#include "script_component.hpp"

params ["_target", "_unit", "_params"];
_params params ["_rackClassName"];

private _actions = [];

/* Stashed Radio */
private _mountedRadio = [_rackClassName] call FUNC(getMountedRadio);

if ([_rackClassName, _unit] call FUNC(isRackAccessible)) then {
    if (_mountedRadio == "") then { // Empty
        if ([_rackClassName] call FUNC(isRadioRemovable)) then {
            private _action = ["acre_mountRadio", localize LSTRING(mountRadio), "\idi\acre\addons\ace_interact\data\icons\connector4.paa", {1+1;}, {true}, {_this call FUNC(generateMountableRadioActions);}, _params] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        } else {
             private _action = ["acre_mountRadio", localize LSTRING(unmountable), "", {1+1;}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    } else {
        private _class = configFile >> "CfgWeapons" >> _mountedRadio;
        private _icon = getText (_class >> "picture");
        if ([_rackClassName] call FUNC(isRadioRemovable)) then {
            private _text = format [localize LSTRING(unmountRadio), getText (_class >> "displayName")];
            private _params = [_rackClassName, _mountedRadio];
            private _action = ["acre_mountedRadio", _text, _icon, {
                params ["_target","_unit","_params"];
                _params params ["_rackClassName"];
                [_rackClassName, _unit] call FUNC(unmountRadio);
            }, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        } else {
            private _text = format [localize LSTRING(mountedRadio), getText (_class >> "displayName")];
            private _action = ["acre_mountedRadio", _text, _icon, {1+1;}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
        if ((toLower _mountedRadio) in ACRE_ACCESSIBLE_RACK_RADIOS) then {
            // stop
            private _action = ["acre_stopMountedRadio", localize LSTRING(stopUsingRadio), "", {
                params ["_target","_unit","_params"];
                _params params ["_mountedRadio"];
                [_target, _unit, _mountedRadio] call FUNC(stopUsingMountedRadio);
            }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];

            private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
            private _radioActions = [_target, _unit, [_mountedRadio, (_mountedRadio isEqualTo ACRE_ACTIVE_RADIO), _pttAssign]] call EFUNC(ace_interact,radioChildrenActions);
            _actions append _radioActions;
        } else {
            // Use
            private _action = ["acre_useMountedRadio", localize LSTRING(useRadio), "", {
                params ["_target", "_unit", "_params"];
                _params params ["_mountedRadio"];
                [_target, _unit, _mountedRadio] call FUNC(startUsingMountedRadio);
            }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];
        };
    };
} else {
    if (_mountedRadio != "") then {
        if ([_rackClassName, _unit] call FUNC(isRackHearable)) then {
            // Radio type
            private _class = configFile >> "CfgWeapons" >> _mountedRadio;
            private _icon = getText (_class >> "picture");
            private _text = format [localize LSTRING(mountedRadio), getText (_class >> "displayName")];
            private _action = ["acre_mountedRadio", _text, _icon, {1+1;}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], _target];

            if ((toLower _mountedRadio) in ACRE_HEARABLE_RACK_RADIOS) then {
                private _action = ["acre_stopMountedRadio", localize LSTRING(stopUsingRadio), "", {
                    params ["_target", "_unit", "_params"];
                    _params params ["_mountedRadio"];
                    [_target, _unit, _mountedRadio] call FUNC(stopUsingMountedRadio);
                }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            } else {
                private _action = ["acre_useMountedRadio", localize LSTRING(useRadio), "", {
                    params ["_target", "_unit", "_params"];
                    _params params ["_mountedRadio"];
                    [_target, _unit, _mountedRadio] call FUNC(startUsingMountedRadio);
                }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };
    };
};

/* Connectors */
if (EGVAR(ace_interact,connectorsEnabled)) then {
    private _action = ["acre_connectors", "Connectors", "\idi\acre\addons\ace_interact\data\icons\connector4.paa", {true /*Statement/Action*/}, {true}, { _this call EFUNC(ace_interact,generateConnectors);}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
