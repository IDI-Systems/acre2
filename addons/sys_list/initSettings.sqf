//--------------------------- UI Customization
// Hint Background Color
[
    QGVAR(hintBgColor),
    "COLOR",
    localize LSTRING(hintBgColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_BG_BLACK],
    false,
    {}
] call CBA_Settings_fnc_init;

// Transmit Color
[
    QGVAR(broadcastColor),
    "COLOR",
    localize LSTRING(broadcastColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_Settings_fnc_init;

// Channel Switch Color
[
    QGVAR(switchChannelColor),
    "COLOR",
    localize LSTRING(switchChannelColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_Settings_fnc_init;

// Toggle Headset Color
[
    QGVAR(toggleHeadsetColor),
    "COLOR",
    localize LSTRING(toggleHeadsetColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_Settings_fnc_init;

// Cycle Radios Color
[
    QGVAR(cycleRadiosColor),
    "COLOR",
    localize LSTRING(cycleRadiosColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_Settings_fnc_init;

// Babel Color
[
    QGVAR(languageColor),
    "COLOR",
    localize LSTRING(languageColor_displayName),
    "ACRE2 UI",
    [ACRE_NOTIFICATION_RED],
    false,
    {}
] call CBA_Settings_fnc_init;

// Hint Text Font
[
    QGVAR(hintTxtFont),
    "LIST",
    localize LSTRING(hintTxtFont_displayName),
    "ACRE2 UI",
    [
    ["EtelkaMonospacePro",
    "EtelkaMonospaceProBold",
    "LCD14",
    "PuristaBold",
    "PuristaLight",
    "PuristaMedium",
    "PuristaSemibold",
    "RobotoCondensed",
    "RobotoCondensedBold",
    "RobotoCondensedLight",
    "TahomaB"],

    ["EtelkaMonospacePro",
    "EtelkaMonospaceProBold",
    "LCD14",
    "PuristaBold",
    "PuristaLight",
    "PuristaMedium",
    "PuristaSemibold",
    "RobotoCondensed",
    "RobotoCondensedBold",
    "RobotoCondensedLight",
    "TahomaB"],
    10],
    false,
    {}
] call CBA_Settings_fnc_init;
