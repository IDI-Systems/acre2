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


// Basic Mission settings (global)
[
    QGVAR(sideFrequenciesAndBabel),
    "LIST",
    ["Side Frequencies / Babel", "Sets unique side radio frequencies and babel language settings."],
    "ACRE2",
    [[
        [false, 0], [false, 1], [false, 2],
        [true, 0], [true, 1], [true, 2]
    ], [
        "Common Freq. / No Babel", "Common Freq. / Per-Side Babel", "Common Freq. / Per-Side + Common Babel",
        "Unique Freq. / No Babel", "Unique Freq. / Per-Side Babel", "Unique Freq. / Per-Side + Common Babel"
    ], 0],
    true,
    {_this call FUNC(setupFrequenciesAndBabel)}
] call CBA_Settings_fnc_init;


// Default radio settings (global)
private _allRadios = call FUNC(getAllRadios);
private _allRadiosClasses = [""];
_allRadiosClasses append (_allRadios select 0);
private _allRadiosNames = ["None"];
_allRadiosNames append (_allRadios select 1);

[
    QGVAR(defaultRadio1),
    "LIST",
    ["Default Radio 1", "Default first radio for to give to player."],
    "ACRE2",
    [_allRadiosClasses, _allRadiosNames, _allRadiosClasses find "ACRE_PRC343"],
    true,
    {[0, _this] call FUNC(setupDefaultRadios)}
] call CBA_Settings_fnc_init;

[
    QGVAR(defaultRadio2),
    "LIST",
    ["Default Radio 2", "Default second radio for to give to player."],
    "ACRE2",
    [_allRadiosClasses, _allRadiosNames, 0],
    true,
    {[1, _this] call FUNC(setupDefaultRadios)}
] call CBA_Settings_fnc_init;

[
    QGVAR(defaultRadio3),
    "LIST",
    ["Default Radio 3", "Default third radio for to give to player."],
    "ACRE2",
    [_allRadiosClasses, _allRadiosNames, 0],
    true,
    {[2, _this] call FUNC(setupDefaultRadios)}
] call CBA_Settings_fnc_init;

[
    QGVAR(defaultRadio4),
    "LIST",
    ["Default Radio 4", "Default fourth radio for to give to player."],
    "ACRE2",
    [_allRadiosClasses, _allRadiosNames, 0],
    true,
    {[3, _this] call FUNC(setupDefaultRadios)}
] call CBA_Settings_fnc_init;
