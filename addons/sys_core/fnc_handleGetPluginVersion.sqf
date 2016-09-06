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

// KEEP THIS IN DEBUG MODE FOR DIAGNOSTICS PURPOSES!

// KEEP THIS IN DEBUG MODE FOR DIAGNOSTICS PURPOSES!
#include "script_component.hpp"
// for testing below...
GVAR(pluginVersion) = _this select 0;
private ["_warn", "_str", "_isServer", "_isClient"];
_warn = false;
_isServer = false;
_isClient = false;
if(!isNil "ACRE_FULL_SERVER_VERSION") then {
    if(ACRE_FULL_SERVER_VERSION != QUOTE(VERSION)) then {
        _warn = true;
        _isServer = true;
    };
};
if(GVAR(pluginVersion) != QUOTE(VERSION_PLUGIN)) then {
    _warn = true;
    _isClient = true;
};

if(!ACRE_SPIT_VERSION) then {
    if(!isNil "ACRE_FULL_SERVER_VERSION") then {
        ACRE_SPIT_VERSION = true;
        _str = format["ACRE Version Information: Plugin:[%1], Addon:[%2], Server:[%3]",GVAR(pluginVersion), QUOTE(VERSION), ACRE_FULL_SERVER_VERSION];
        LOG(_str);
    };
};

if(_warn) then {
    ACRE_HAS_WARNED = true;
    _warning = "ACRE: Plugin version and Addon version do not match!";
    if(_isServer) then {
        _warning = "ACRE: Server version and client version do not match!";
    };
    if(_isClient && _isServer) then {
        _warning = "ACRE: Server version and client version do not match. Client does not match plugin!";
    };
    hint _warning;
    GVAR(wrongVersionIncrease) = GVAR(wrongVersionIncrease) + 1;
    _str = format["!!!!!!!!!!!!!!!!! ACRE: Mismatched plugin and addon! Plugin:[%1], Addon:[%2], Server:[%3] !!!!!!!!!!!!!!!!! ",GVAR(pluginVersion), QUOTE(VERSION), ACRE_FULL_SERVER_VERSION];
    LOG(_str);
    if(GVAR(wrongVersionIncrease) >= 5) then {
        titleText [_warning, "BLACK OUT", 15];
    };
} else {
    if(ACRE_HAS_WARNED) then {
        ACRE_HAS_WARNED = false;
        titleFadeOut 0;
    };
};

true
