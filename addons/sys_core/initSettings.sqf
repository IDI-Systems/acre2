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
    QGVAR(unmuteClients),
    "CHECKBOX",
    localize LSTRING(unmuteClients_displayName),
    "ACRE2",
    true,
    false,
    {["disableUnmuteClients", _this] call FUNC(setPluginSetting)}
] call CBA_fnc_addSetting;

// VOIP Channel Switching
// Switch channels
[
    QGVAR(voipChannelSwitch),
    "CHECKBOX",
    localize LSTRING(voipChannelSwitch_displayName),
    "ACRE2",
    true,
    false,
    {["disableVoipChannelSwitch", _this] call FUNC(setPluginSetting)}
] call CBA_fnc_addSetting;

// Channel Name
[
    QGVAR(voipChannelName),
    "EDITBOX",
    localize LSTRING(voipChannelName_displayName),
    "ACRE2",
    "",
    true,
    {if (!isNull (findDisplay 46)) then {call EFUNC(sys_io,voipChannelMove)};}
] call CBA_fnc_addSetting;

// Channel Password
[
    QGVAR(voipChannelPassword),
    "EDITBOX",
    localize LSTRING(voipChannelPassword_displayName),
    "ACRE2",
    ["", true],
    true,
    {if (!isNull (findDisplay 46)) then {call EFUNC(sys_io,voipChannelMove)};}
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

if ("ACRE2Arma" callExtension "99" == "1") then {
  // Wine Socket Port
  [
    QGVAR(wineSocketPort),
    "EDITBOX",
    ["Wine Socket Port", "(Linux only) What port should ACRE2 try to connect to Mumble on?"],
    "ACRE2 Wine",
    "19141",
    false
  ] call CBA_fnc_addSetting;
};

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
