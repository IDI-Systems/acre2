#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the return of the current plugin version from TeamSpeak. Displays messages to the player if any of the versions do not match.
 *
 * Arguments:
 * 0: TeamSpeak plugin version <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["2.3.0.926"] call acre_sys_core_fnc_handleGetPluginVersion
 *
 * Public: No
 */
// for testing below...
GVAR(pluginVersion) = _this select 0;

private _warn = false;
private _isServer = false;
private _isClient = false;

if (!isNil "ACRE_FULL_SERVER_VERSION") then {
    if (ACRE_FULL_SERVER_VERSION != QUOTE(VERSION)) then {
        _warn = true;
        _isServer = true;
    };
};
if (GVAR(pluginVersion) != QUOTE(VERSION_PLUGIN)) then {
    _warn = true;
    _isClient = true;
};

if (!ACRE_SPIT_VERSION && {!isNil "ACRE_FULL_SERVER_VERSION"}) then {
    ACRE_SPIT_VERSION = true;
    INFO_3("Version information. Plugin: %1 - Client: %1 - Server: %3",GVAR(pluginVersion),QUOTE(VERSION),ACRE_FULL_SERVER_VERSION);
};

if (_warn) then {
    ACRE_HAS_WARNED = true;
    ERROR_WITH_TITLE_3("Mismatched TeamSpeak plugin or mod versions!","\nTeamSpeak plugin version: %1\nYour version: %2\nServer version: %3",GVAR(pluginVersion),QUOTE(VERSION),ACRE_FULL_SERVER_VERSION);
} else {
    if (ACRE_HAS_WARNED) then {
        ACRE_HAS_WARNED = false;
        titleFadeOut 0;
    };
};

true
