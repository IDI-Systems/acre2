/*
 * Author: AUTHOR
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

TRACE_1("Enter", _this);

private ["_menuDef", "_target", "_params", "_menuName", "_menuRsc", "_menus"];
// _this==[_target, _menuNameOrParams]
_target = _this select 0;
_params = _this select 1;

_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
    if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__];};
    _menuName = _params select 0;
    _menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
    _menuName = _params;
};
//-----------------------------------------------------------------------------

_menus = [
    [
        ["main", "Spectator Menu", _menuRsc],
        [
            ["Mute Dead Channel",
                { ["toggledead"] call FUNC(interactMenu_deadMenu_actions) },
                "", "", "", -1,
                1, (!GVAR(spect_muteDead))],
            ["Unmute Dead Channel",
                { ["toggledead"] call FUNC(interactMenu_deadMenu_actions) },
                "", "", "", -1,
                1, (GVAR(spect_muteDead))],
            ["Mute Alive Channel",
                { ["togglealive"] call FUNC(interactMenu_deadMenu_actions) },
                "", "", "", -1,
                1, (!GVAR(spect_muteAlive))],
            ["Unmute Alive Channel",
                { ["togglealive"] call FUNC(interactMenu_deadMenu_actions) },
                "", "", "", -1,
                1, (GVAR(spect_muteAlive))],
            ["Adjust Global Volume",
                { hint "not implemented"; true },
                "", "", "", -1,
                1, (true)]
        ]
    ]
];


//-----------------------------------------------------------------------------
_menuDef = [];
{
    if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
    hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this}else{""}, __FILE__];
    diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _this, __FILE__];
};

_menuDef // return value
