#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Create and return ace actions for assigning Push-To-Talk buttons.
 *
 * Arguments:
 * 0: Target (Player) <OBJECT>
 * 1: Player <OBJECT>
 * 2: Arguments <ARRAY>
 *      0: Radio ID <STRING>
 *      1: Unused <ANY>
 *      2: The array of radio ID’s which are assigned to each PTT key. These are returned in order, from key 1-3 <ARRAY>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * _this call acre_ace_interact_fnc_radioPTTChildrenActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_radio", "", "_pttAssign"];

private _actions = [];
private _idx = _pttAssign find _radio;

for "_i" from 1 to 3 do {
    if (count _pttAssign > (_i - 1) && _idx isNotEqualTo (_i - 1)) then {
        private _text = format [LLSTRING(setAsMultiPTT), _i];
        private _icon = format [QPATHTOF(data\icons\ptt_%1.paa), _i];
        private _action = [format [QGVAR(mpttAssign%1), _i], _text, _icon, LINKFUNC(actionSetMTT), {true}, {}, [_radio, _pttAssign, _i - 1]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
};

_actions
