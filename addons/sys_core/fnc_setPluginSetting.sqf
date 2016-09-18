/*
 * Author: ACRE2Team
 * Handles setting TeamSpeak plugin settings. Waits for pipe to open and then applies them.
 *
 * Arguments:
 * 0: Setting Name <STRING>
 * 1: Setting Value <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["globalVolume", "1.5"] call acre_sys_core_fnc_setPluginSetting
 *
 * Public: No
 */
#include "script_component.hpp"

// Can only be connected in multiplayer or in debug mode
#ifndef DEBUG_MODE_FULL
if (!isMultiplayer) exitWith {};
#endif

params ["_name", "_value"];

// Plugin initialized, apply setting directly
if (EGVAR(sys_io,serverStarted)) exitWith {
    ["setSetting", [_name, _value]] call EFUNC(sys_rpc,callRemoteProcedure);
};

// Already waiting for plugin initialization, add setting to delayed settings array
if !(GVAR(delayedPluginSettings) isEqualTo []) exitWith {
    // Filter settings already set in case of prolonged wait where user can modify it multiple times
    GVAR(delayedPluginSettings) = GVAR(delayedPluginSettings) select {_x select 0 != _name};
    GVAR(delayedPluginSettings) pushBack _this;
};

// Start PFH for waiting for plugin initialization
GVAR(delayedPluginSettings) = [_this];
[{
    if (EGVAR(sys_io,serverStarted)) exitWith {
        // Save settings to local variable in case settings are changed while delayed ones are being applied
        private _delayedSettings = GVAR(delayedPluginSettings);
        GVAR(delayedPluginSettings) = [];

        [_this select 1] call CBA_fnc_removePerFrameHandler;

        // Set settings in plugin
        {
            _x params ["_name", "_value"];
            ["setSetting", [_name, _value]] call EFUNC(sys_rpc,callRemoteProcedure);
        } forEach _delayedSettings;
    };
}, 1, []] call CBA_fnc_addPerFrameHandler;
