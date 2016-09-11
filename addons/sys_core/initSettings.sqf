// Plugin Settings (local)
[
    QGVAR(postmixGlobalVolume),
    "SLIDER",
    "Post-Mix Global Volume",
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["globalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

[
    QGVAR(premixGlobalVolume),
    "SLIDER",
    "Pre-Mix Global Volume",
    "ACRE2",
    [0, 3, 1, 2],
    false,
    {["premixGlobalVolume", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

[
    QGVAR(unmuteClients),
    "CHECKBOX",
    "Unmute Clients",
    "ACRE2",
    true,
    false,
    {["disableUnmuteClients", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;


// Difficulty settings (global)
[
    QGVAR(signalLoss),
    "CHECKBOX",
    ["Signal Loss", "Enables signal and terrain loss."],
    "ACRE2",
    true,
    true,
    {if (!_this) then {[0.0] call FUNC(setLossModelScale)}}
] call CBA_Settings_fnc_init;

[
    QGVAR(fullDuplex),
    "CHECKBOX",
    ["Full-Duplex Transmissions", "Allows multiple people to transmit simultaneously."],
    "ACRE2",
    false,
    true,
    {if (_this) then {[true] call acre_api_fnc_setFullDuplex}}
] call CBA_Settings_fnc_init;

[
    QGVAR(interference),
    "CHECKBOX",
    ["Signal Interference", "Enables interference from multiple transmitters."],
    "ACRE2",
    true,
    true,
    {if (!_this) then {[false] call acre_api_fnc_setInterference}}
] call CBA_Settings_fnc_init;

[
    QGVAR(ignoreAntennaDirection),
    "CHECKBOX",
    ["Ignore Antenna Direction", "Enables loss due to antenna directional radiation patterns."],
    "ACRE2",
    false,
    true,
    {if (_this) then {[true] call acre_api_fnc_ignoreAntennaDirection}}
] call CBA_Settings_fnc_init;
