#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Applies an audio setting (global volumes, radio noise) in the voice extension.
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

if (!hasInterface) exitWith {};

params ["_name", "_value"];

// The voice extension keeps settings across (re)connections, so they can be applied any time.
switch (_name) do {
    case "globalVolume";
    case "premixGlobalVolume": {
        ["settings:set", [_name, _value]] call EFUNC(sys_io,ext);
    };
    case "disableRadioNoise": {
        // The CBA setting is "radio noise enabled", despite the name.
        ["settings:set", ["radioNoise", [0, 1] select _value]] call EFUNC(sys_io,ext);
    };
    default {
        WARNING_1("Unknown plugin setting %1",_name);
    };
};
