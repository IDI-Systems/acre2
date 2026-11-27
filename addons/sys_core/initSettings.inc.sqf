[
    QGVAR(postmixGlobalVolume),
    "SLIDER",
    localize LSTRING(postmixGlobalVolume_displayName),
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["globalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_fnc_addSetting;

[
    QGVAR(premixGlobalVolume),
    "SLIDER",
    localize LSTRING(premixGlobalVolume_displayName),
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["premixGlobalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_fnc_addSetting;

[
    QGVAR(defaultRadioVolume),
    "LIST",
    localize LSTRING(defaultRadioVolume_displayName),
    "ACRE2",
    [[0.2, 0.4, 0.6, 0.8, 1], ["20%", "40%", "60%", "80%", "100%"], 3]
] call CBA_fnc_addSetting;

[
    QGVAR(spectatorVolume),
    "SLIDER",
    localize LSTRING(spectatorVolume_displayName),
    "ACRE2",
    [0, 1, 1, 2],
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(godVolume),
    "SLIDER",
    localize LSTRING(godVolume_displayName),
    "ACRE2",
    [0.2, 1, 1, 2], // Minimal value so it always stays hearable
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(radioNoise),
    "CHECKBOX",
    localize LSTRING(radioNoise_displayName),
    "ACRE2",
    true,
    false,
    {["disableRadioNoise", _this] call FUNC(setPluginSetting)}
] call CBA_fnc_addSetting;

// Voice: how direct speech is triggered (any radio/intercom/zeus/god PTT always transmits)
[
    QGVAR(voiceActivation),
    "LIST",
    [localize LSTRING(voiceActivation_displayName), localize LSTRING(voiceActivation_description)],
    "ACRE2",
    [[0, 1], [localize LSTRING(voiceActivation_vad), localize LSTRING(voiceActivation_ptt)], 0],
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

[
    QGVAR(voiceThreshold),
    "SLIDER",
    [localize LSTRING(voiceThreshold_displayName), localize LSTRING(voiceThreshold_description)],
    "ACRE2",
    [-80, -10, -45, 0],
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

[
    QGVAR(voiceThresholdClose),
    "SLIDER",
    [localize LSTRING(voiceThresholdClose_displayName), localize LSTRING(voiceThresholdClose_description)],
    "ACRE2",
    [-80, -10, -50, 0],
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

// Microphone filter (RNNoise): background noise removal, and voice activation that only opens
// on speech (not keyboard clacks or other loud noises).
[
    QGVAR(noiseSuppression),
    "CHECKBOX",
    [localize LSTRING(noiseSuppression_displayName), localize LSTRING(noiseSuppression_description)],
    "ACRE2",
    true,
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

[
    QGVAR(speechDetection),
    "CHECKBOX",
    [localize LSTRING(speechDetection_displayName), localize LSTRING(speechDetection_description)],
    "ACRE2",
    true,
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

// How long a push-to-talk keeps transmitting after it's released, so the last word isn't cut
// off. acre_api_fnc_setPTTDelay still overrides it.
[
    QGVAR(pttReleaseDelay),
    "SLIDER",
    [localize LSTRING(pttReleaseDelay_displayName), localize LSTRING(pttReleaseDelay_description)],
    "ACRE2",
    [0, 1, 0.2, 2],
    false,
    {
        params ["_value"];
        ACRE_PTT_RELEASE_DELAY = _value;
    }
] call CBA_fnc_addSetting;

// Hear yourself on your other radios (or a loudspeaker radio near you) tuned to the channel
// you're transmitting on.
[
    QGVAR(selfHearing),
    "CHECKBOX",
    [localize LSTRING(selfHearing_displayName), localize LSTRING(selfHearing_description)],
    "ACRE2",
    true,
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

// Audio devices: dropdowns of what this machine has ("" is the system default). A device that
// is no longer present falls back to the default.
private _inputDevices = [[""], [localize LSTRING(audioDevice_default)]];
private _outputDevices = [[""], [localize LSTRING(audioDevice_default)]];
if (hasInterface) then {
    private _result = ["audio:devices", []] call EFUNC(sys_io,ext);
    if (_result != "") then {
        (parseSimpleArray _result) params [["_inputs", []], ["_outputs", []]];
        {
            (_inputDevices select 0) pushBack (_x select 0);
            (_inputDevices select 1) pushBack (_x select 1);
        } forEach _inputs;
        {
            (_outputDevices select 0) pushBack (_x select 0);
            (_outputDevices select 1) pushBack (_x select 1);
        } forEach _outputs;
    };
};

[
    QGVAR(inputDevice),
    "LIST",
    [localize LSTRING(inputDevice_displayName), localize LSTRING(audioDevice_description)],
    "ACRE2",
    [_inputDevices select 0, _inputDevices select 1, 0],
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

[
    QGVAR(outputDevice),
    "LIST",
    [localize LSTRING(outputDevice_displayName), localize LSTRING(audioDevice_description)],
    "ACRE2",
    [_outputDevices select 0, _outputDevices select 1, 0],
    false,
    {[] call FUNC(applyVoiceSettings)}
] call CBA_fnc_addSetting;

// Voice server (hosted by the Arma server; server settings)
[
    QEGVAR(sys_server,voicePort),
    "EDITBOX",
    [localize LSTRING(voicePort_displayName), localize LSTRING(voicePort_description)],
    localize LSTRING(voiceServerCategory),
    "9987",
    1,
    {},
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(sys_server,voiceAddress),
    "EDITBOX",
    [localize LSTRING(voiceAddress_displayName), localize LSTRING(voiceAddress_description)],
    localize LSTRING(voiceServerCategory),
    "",
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Difficulty settings
// Interference
[
    QGVAR(interference),
    "CHECKBOX",
    localize LSTRING(interference_displayName),
    "ACRE2",
    true,
    true,
    {[_this] call FUNC(setInterference)}
] call CBA_fnc_addSetting;

// Full duplex
[
    QGVAR(fullDuplex),
    "CHECKBOX",
    localize LSTRING(fullDuplex_displayName),
    "ACRE2",
    false,
    true
] call CBA_fnc_addSetting;

// Antena direction
[
    QGVAR(ignoreAntennaDirection),
    "CHECKBOX",
    localize LSTRING(antennaDirection_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call FUNC(ignoreAntennaDirection)}
] call CBA_fnc_addSetting;

// Antena direction
[
    QGVAR(automaticAntennaDirection),
    "CHECKBOX",
    localize LSTRING(autoAntennaDirection_displayName),
    "ACRE2",
    false
] call CBA_fnc_addSetting;

// Terrain loss
[
    QGVAR(terrainLoss),
    "SLIDER",
    localize LSTRING(terrainLoss_displayName),
    "ACRE2",
    [0, 1, 1, 2],
    true,
    {[_this] call FUNC(setLossModelScale)}
] call CBA_fnc_addSetting;

// Reveal to AI
[
    QGVAR(revealToAI),
    "SLIDER",
    localize LSTRING(revealToAI_displayName),
    "ACRE2",
    [0, 2.50, 1, 2],
    true,
    {[_this] call FUNC(setRevealToAI)}
] call CBA_fnc_addSetting;

// Notification Settings - not yet implemented
/*[
    QGVAR(incomingTransmissionNotification),
    "CHECKBOX",
    localize LSTRING(incomingTransmissionNotification),
    "ACRE2",
    false,
    true,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(rackTransmissionNotification),
    "CHECKBOX",
    localize LSTRING(rackTransmissionNotification),
    "ACRE2",
    false,
    true,
    {}
] call CBA_fnc_addSetting;*/
