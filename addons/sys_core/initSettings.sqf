[
    QGVAR(postmixGlobalVolume),
    "SLIDER",
    localize LSTRING(postmixGlobalVolume_displayName),
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["globalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

[
    QGVAR(premixGlobalVolume),
    "SLIDER",
    localize LSTRING(premixGlobalVolume_displayName),
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["premixGlobalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

[
    "ACRE_SPECTATOR_VOLUME",
    "SLIDER",
    localize LSTRING(ACRE_SPECTATOR_VOLUME_displayName),
    "ACRE2",
    [0, 1, 1, 2],
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(unmuteClients),
    "CHECKBOX",
    localize LSTRING(unmuteClients_displayName),
    "ACRE2",
    true,
    false,
    {["disableUnmuteClients", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

[
    QGVAR(disableDesyncHint),
    "CHECKBOX",
    localize LSTRING(disableDesyncHint_displayName),
    "ACRE2",
    true,
    false,
    {EGVAR(sys_radio,disableDesyncHint) = _this}
] call CBA_Settings_fnc_init;

// Difficulty settings
// Interference
[
    "ACRE_INTERFERENCE",
    "CHECKBOX",
    localize LSTRING(difficultyInterference_displayName),
    "ACRE2",
    true,
    true,
    {[_this] call EFUNC(api,setInterference)}
] call CBA_Settings_fnc_init;

// Full duplex
[
    "ACRE_FULL_DUPLEX",
    "CHECKBOX",
    localize LSTRING(difficultyFullDuplex_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,setFullDuplex)}
] call CBA_Settings_fnc_init;

// Antena direction
[
    QEGVAR(sys_signal,omnidirectionalRadios)
    "CHECKBOX",
    localize LSTRING(difficultyAntennaDirection_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,ignoreAntennaDirection)}
] call CBA_Settings_fnc_init;

// Terrain loss
[
    QEGVAR(sys_signal,terrainScaling)
    "SLIDER",
    localize LSTRING(difficultyTerrainLoss_displayName),
    "ACRE2",
    [0, 1, 1, 2],
    true,
    {[_this] call EFUNC(api,setLossModelScale)}
] call CBA_Settings_fnc_init;

// Reveal to AI
[
    "ACRE_AI_ENABLED",
    "CHECKBOX",
    localize LSTRING(difficultyRevealToAI_displayName),
    "ACRE2",
    true,
    true,
    {[_this] call EFUNC(api,setRevealToAI)}
] call CBA_Settings_fnc_init;
