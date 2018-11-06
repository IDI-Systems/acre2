#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates actions for controlling the spatial set-up of a radio
 *
 * Arguments:
 * 0: Unit with a radio <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: unused, unused, unused, current spatial configuration <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [acre_player, "", ["", "", "", "LEFT"]] call acre_ace_interact_fnc_externalRadioVehicleListChildrenActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_radioID", "", "", "_spatial"];

private _actions  = [];

if (_spatial != "RIGHT") then {
    private _action = [QGVAR(audioRight), localize ELSTRING(sys_core,switchRadioEarRight), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [1, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "CENTER") then {
    private _action = [QGVAR(audioCenter), localize ELSTRING(sys_core,switchRadioEarBoth), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [0, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "LEFT") then {
    private _action = [QGVAR(audioLeft), localize ELSTRING(sys_core,switchRadioEarLeft), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [-1, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
