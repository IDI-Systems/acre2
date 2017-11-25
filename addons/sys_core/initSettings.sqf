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

// Teamspeak Channel Switching
// Switch channels
[
    QGVAR(ts3ChannelSwitch),
    "CHECKBOX",
    localize LSTRING(ts3ChannelSwitch_displayName),
    "ACRE2",
    true,
    false,
    {["disableTS3ChannelSwitch", _this] call FUNC(setPluginSetting)}
] call CBA_Settings_fnc_init;

// Channel Name
[
    QGVAR(ts3ChannelName),
    "EDITBOX",
    localize LSTRING(ts3ChannelName_displayName),
    "ACRE2",
    "",
    true,
    {if (!isNull (findDisplay 46)) then {call EFUNC(sys_io,ts3ChannelMove)};}
] call CBA_Settings_fnc_init;

// Channel Password
[
    QGVAR(ts3ChannelPassword),
    "EDITBOX",
    localize LSTRING(ts3ChannelPassword_displayName),
    "ACRE2",
    "",
    true,
    {if (!isNull (findDisplay 46)) then {call EFUNC(sys_io,ts3ChannelMove)};}
] call CBA_Settings_fnc_init;

// Difficulty settings
// Interference
[
    QGVAR(interference),
    "CHECKBOX",
    localize LSTRING(interference_displayName),
    "ACRE2",
    true,
    true,
    {[_this, true] call EFUNC(api,setInterference)} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

// Full duplex
[
    QGVAR(fullDuplex),
    "CHECKBOX",
    localize LSTRING(fullDuplex_displayName),
    "ACRE2",
    false,
    true,
    {[_this, true] call EFUNC(api,setFullDuplex)} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

// Antena direction
[
    QGVAR(ignoreAntennaDirection),
    "CHECKBOX",
    localize LSTRING(antennaDirection_displayName),
    "ACRE2",
    false,
    true,
    {[_this, true] call EFUNC(api,ignoreAntennaDirection)} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

// Terrain loss
[
    QGVAR(terrainLoss),
    "SLIDER",
    localize LSTRING(terrainLoss_displayName),
    "ACRE2",
    [0, 1, 0.50, 2],
    true,
    {[_this, true] call EFUNC(api,setLossModelScale)} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

// Reveal to AI
[
    QGVAR(revealToAI),
    "CHECKBOX",
    localize LSTRING(revealToAI_displayName),
    "ACRE2",
    true,
    true,
    {[_this, true] call EFUNC(api,setRevealToAI)} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

// @todo remove in 2.7.0
// Module settings
// Applies the difficulty module settings over CBA settings. If the module is not present, this function has no effect.
["CBA_beforeSettingsInitialized", {
    private _missionModules = allMissionObjects "acre_api_DifficultySettings";
    if (count _missionModules == 0) exitWith {};

    private _fullDuplex = (_missionModules select 0) getVariable ["FullDuplex", false];
    private _interference = (_missionModules select 0) getVariable ["Interference", true];
    private _ignoreAntennaDirection = (_missionModules select 0) getVariable ["IgnoreAntennaDirection", false];
    private _signalLoss = (_missionModules select 0) getVariable ["SignalLoss", true];

    //@todo remove force when CBA issue fixed: https://github.com/CBATeam/CBA_A3/issues/580
    ["CBA_settings_setSettingMission", [QGVAR(interference), _interference, true]] call CBA_fnc_localEvent;
    ["CBA_settings_setSettingMission", [QGVAR(fullDuplex), _fullDuplex, true]] call CBA_fnc_localEvent;
    ["CBA_settings_setSettingMission", [QGVAR(ignoreAntennaDirection), _ignoreAntennaDirection, true]] call CBA_fnc_localEvent;
    ["CBA_settings_setSettingMission", [QGVAR(terrainLoss), parseNumber _signalLoss, true]] call CBA_fnc_localEvent;
}] call CBA_fnc_addEventHandler;
