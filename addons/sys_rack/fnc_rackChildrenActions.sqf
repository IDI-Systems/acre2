/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target","_unit","_params"];
_params params ["_rackClassName"];

private _actions = [];

/* Stashed Radio */
private _mountedRadio = [_rackClassName] call FUNC(getMountedRadio);

if (_mountedRadio == "") then { // Empty
    if ([_rackClassName] call FUNC(isRadioRemovable)) then {
        private _action = ["acre_mountRadio", "Mount Radio", "\idi\acre\addons\ace_interact\data\icons\connector4.paa", {1+1;}, {true}, {_this call FUNC(generateMountableRadioActions);}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    } else {
         private _action = ["acre_mountRadio", "Unmountable (Locked)", "", {1+1;}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} else {
    private _class = configFile >> "CfgWeapons" >> _mountedRadio;
    private _icon = getText (_class >> "picture");

    if ([_rackClassName] call FUNC(isRadioRemovable)) then {
        private _text = format ["Unmount Radio (%1)",getText (_class >> "displayName")];
        private _params = [_rackClassName,_mountedRadio];
        private _action = ["acre_mountedRadio", _text, _icon, {
            params ["_target","_unit","_params"];
            _params params ["_rackClassName"];
            [_rackClassName,_unit] call FUNC(unmountRadio);
        }, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    } else {
        private _text = format ["Mounted radio (%1)",getText (_class >> "displayName")];
        private _action = ["acre_mountedRadio", _text, _icon, {1+1;}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
    if ((toLower _mountedRadio) in ACRE_ACTIVE_RACK_RADIOS) then {
        // stop
        private _action = ["acre_stopMountedRadio", "Stop using radio", "", {
            params ["_target","_unit","_params"];
            _params call FUNC(stopUsingMountedRadio);
        }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
        private _radioActions = [_target,_unit,[_mountedRadio,(_mountedRadio isEqualTo ACRE_ACTIVE_RADIO), _pttAssign]] call FUNC(radioChildrenActions);
        _actions append _radioActions;
    } else {
        // Use
        private _action = ["acre_stopMountedRadio", "Use radio", "", {
            params ["_target","_unit","_params"];
            _params params ["_mountedRadio"];
            ACRE_ACTIVE_RADIO = toLower _mountedRadio;
            ACRE_ACTIVE_RACK_RADIOS pushBackUnique (toLower _mountedRadio);
        }, {true}, {}, [_mountedRadio]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
};

/* Connectors */
if (EGVAR(ace_interact,connectorsEnabled)) then {
    private _action = ["acre_connectors", "Connectors", "\idi\acre\addons\ace_interact\data\icons\connector4.paa", {true /*Statement/Action*/}, {true}, { _this call EFUNC(ace_interact,generateConnectors);}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
