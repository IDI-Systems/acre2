#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Applies the voice activation and audio device settings to the voice extension.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_applyVoiceSettings
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

private _mode = ["vad", "ptt"] select (missionNamespace getVariable [QGVAR(voiceActivation), 0]);
private _open = missionNamespace getVariable [QGVAR(voiceThreshold), -45];
private _close = (missionNamespace getVariable [QGVAR(voiceThresholdClose), -50]) min _open;
["vox:settings", [_mode, _open, _close]] call EFUNC(sys_io,ext);
[
    "vox:noise",
    [
        missionNamespace getVariable [QGVAR(noiseSuppression), true],
        missionNamespace getVariable [QGVAR(speechDetection), true]
    ]
] call EFUNC(sys_io,ext);
["tx:loopback", [missionNamespace getVariable [QGVAR(selfHearing), true]]] call EFUNC(sys_io,ext);

private _devices = [
    missionNamespace getVariable [QGVAR(inputDevice), ""],
    missionNamespace getVariable [QGVAR(outputDevice), ""]
];
if (_devices isNotEqualTo GVAR(lastAudioDevices)) then {
    GVAR(lastAudioDevices) = _devices;
    ["audio:select", _devices] call EFUNC(sys_io,ext);
};
