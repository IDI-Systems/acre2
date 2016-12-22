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
    QGVAR(spectatorVolume),
    "SLIDER",
    localize LSTRING(spectatorVolume_displayName),
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
    QGVAR(interference),
    "CHECKBOX",
    localize LSTRING(Interference_displayName),
    "ACRE2",
    true,
    true,
    {[_this] call EFUNC(api,setInterference)}
] call CBA_Settings_fnc_init;

// Full duplex
[
    QGVAR(fullDuplex),
    "CHECKBOX",
    localize LSTRING(FullDuplex_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,setFullDuplex)}
] call CBA_Settings_fnc_init;

// Antena direction
[
    QGVAR(ignoreAntenaDirection),
    "CHECKBOX",
    localize LSTRING(AntennaDirection_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,ignoreAntennaDirection)}
] call CBA_Settings_fnc_init;

// Terrain loss
[
    QGVAR(terrainLoss),
    "SLIDER",
    localize LSTRING(TerrainLoss_displayName),
    "ACRE2",
    [0, 1, 1, 2],
    true,
    {[_this] call EFUNC(api,setLossModelScale)}
] call CBA_Settings_fnc_init;

// Reveal to AI
[
    QGVAR(revealToAI),
    "CHECKBOX",
    localize LSTRING(RevealToAI_displayName),
    "ACRE2",
    true,
    true,
    {[_this] call EFUNC(api,setRevealToAI)}
] call CBA_Settings_fnc_init;
