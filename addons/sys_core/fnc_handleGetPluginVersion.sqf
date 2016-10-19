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
// for testing below...
GVAR(pluginVersion) = _this select 0;

private _warn = false;
private _isServer = false;
private _isClient = false;

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

if (!ACRE_SPIT_VERSION && {!isNil "ACRE_FULL_SERVER_VERSION"}) then {
    ACRE_SPIT_VERSION = true;
    INFO_3("Version information. Plugin: %1 - Client: %1 - Server: %3",GVAR(pluginVersion),QUOTE(VERSION),ACRE_FULL_SERVER_VERSION);
};

if(_warn) then {
    ACRE_HAS_WARNED = true;
    ERROR_WITH_TITLE_3("Mismatched TeamSpeak plugin and mod versions!","\nPlugin: %1\nMod: %2\nServer: %3",GVAR(pluginVersion),QUOTE(VERSION),ACRE_FULL_SERVER_VERSION);
} else {
    if(ACRE_HAS_WARNED) then {
        ACRE_HAS_WARNED = false;
        titleFadeOut 0;
    };
};

true
