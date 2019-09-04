// Hint Text Font
private _fontNames = ["Etelka Monospace Pro", "Etelka Monospace Pro Bold", "LCD 14", "Purista Bold", "Purista Light", "Purista Medium", "Purista SemiBold", "Roboto Condensed", "Roboto Condensed Bold", "Roboto Condensed Light", "Tahoma B"];
private _fonts = ["EtelkaMonospacePro", "EtelkaMonospaceProBold", "LCD14", "PuristaBold", "PuristaLight", "PuristaMedium", "PuristaSemibold", "RobotoCondensed", "RobotoCondensedBold", "RobotoCondensedLight", "TahomaB"];
[
    QGVAR(HintTextFont),
    "LIST",
    localize LSTRING(HintTextFont_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [_fonts, _fontNames, 7],
    false,
    {}
] call CBA_fnc_addSetting;

// Hint Background Color
[
    QGVAR(HintBackgroundColor),
    "COLOR",
    localize LSTRING(HintBackgroundColor_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [ACRE_NOTIFICATION_BG_BLACK],
    false,
    {}
] call CBA_fnc_addSetting;

// Channel Switch Color
[
    QGVAR(SwitchChannelColor),
    "COLOR",
    localize LSTRING(SwitchChannelColor_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Toggle Headset Color
[
    QGVAR(ToggleHeadsetColor),
    "COLOR",
    localize LSTRING(ToggleHeadsetColor_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Cycle Radios Color
[
    QGVAR(CycleRadiosColor),
    "COLOR",
    localize LSTRING(CycleRadiosColor_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Babel Color
[
    QGVAR(LanguageColor),
    "COLOR",
    localize LSTRING(LanguageColor_DisplayName),
    ELSTRING(sys_core,CategoryUI),
    [ACRE_NOTIFICATION_RED],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT1 Color
[
    QGVAR(PTT1Color),
    "COLOR",
    localize LSTRING(PTT1Color_DisplayName),
    [ELSTRING(sys_core,CategoryUI), "PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT2 Color
[
    QGVAR(PTT2Color),
    "COLOR",
    localize LSTRING(PTT2Color_DisplayName),
    [ELSTRING(sys_core,CategoryUI), "PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT3 Color
[
    QGVAR(PTT3Color),
    "COLOR",
    localize LSTRING(PTT3Color_DisplayName),
    [ELSTRING(sys_core,CategoryUI), "PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// Default PTT Color
[
    QGVAR(DefaultPTTColor),
    "COLOR",
    localize LSTRING(DefaultPTTColor_DisplayName),
    [ELSTRING(sys_core,CategoryUI), "PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;
