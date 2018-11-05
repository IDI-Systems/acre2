#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of volume actions for the intercom network of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomListVolumeActions
 *
 * Public: No
 */

params ["_target", "_player", "_intercomNetwork"];
private _actions = [];

private _volume = [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
if (_volume != 0.0) then {
    private _action = [QGVAR(volumeMute), localize LSTRING(mute), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 0.0] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (_volume != 0.2) then {
    private _action = [QGVAR(volume20), "20%", "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 0.2] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (_volume != 0.4) then {
    private _action = [QGVAR(volume40), "40%", "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 0.4] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (_volume != 0.6) then {
    private _action = [QGVAR(volume60), "60%", "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 0.6] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (_volume != 0.8) then {
    private _action = [QGVAR(volume80), "80%", "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 0.8] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (_volume != 1.0) then {
    private _action = [QGVAR(volume100), "100%", "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_VOLUME, 1.0] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
