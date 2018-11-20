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
    ["", true],
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
    {[_this] call EFUNC(api,setInterference)}
] call CBA_Settings_fnc_init;

// Full duplex
[
    QGVAR(fullDuplex),
    "CHECKBOX",
    localize LSTRING(fullDuplex_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,setFullDuplex)}
] call CBA_Settings_fnc_init;

// Antena direction
[
    QGVAR(ignoreAntennaDirection),
    "CHECKBOX",
    localize LSTRING(antennaDirection_displayName),
    "ACRE2",
    false,
    true,
    {[_this] call EFUNC(api,ignoreAntennaDirection)}
] call CBA_Settings_fnc_init;

// Antena direction
[
    QGVAR(automaticAntennaDirection),
    "CHECKBOX",
    localize LSTRING(autoAntennaDirection_displayName),
    "ACRE2",
    false
] call CBA_Settings_fnc_init;

// Terrain loss
[
    QGVAR(terrainLoss),
    "SLIDER",
    localize LSTRING(terrainLoss_displayName),
    "ACRE2",
    [0, 1, 0.50, 2],
    true,
    {[_this] call EFUNC(api,setLossModelScale)}
] call CBA_Settings_fnc_init;

// Reveal to AI
[
    QGVAR(revealToAI),
    "SLIDER",
    localize LSTRING(revealToAI_displayName),
    "ACRE2",
    [0, 2.50, 1, 2],
    true,
    {[_this] call EFUNC(api,setRevealToAI)}
] call CBA_Settings_fnc_init;

// Notification Settings
/*[
    QGVAR(incomingTransmissionNotification),
    "CHECKBOX",
    localize LSTRING(incomingTransmissionNotification),
    "ACRE2",
    false,
    true,
    {} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;

[
    QGVAR(rackTransmissionNotification),
    "CHECKBOX",
    localize LSTRING(rackTransmissionNotification),
    "ACRE2",
    false,
    true,
    {} // @todo remove second parameter in 2.7.0
] call CBA_Settings_fnc_init;*/
