// Hint Background Color
[
    QGVAR(HintBGColor),
    "COLOR",
    localize LSTRING(HintBGColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_BG_BLACK],
    false,
    {}
] call CBA_fnc_addSetting;

// Transmit Color
[
    QGVAR(TransmissionColor),
    "COLOR",
    localize LSTRING(TransmissionColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// Channel Switch Color
[
    QGVAR(SwitchChannelColor),
    "COLOR",
    localize LSTRING(SwitchChannelColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Toggle Headset Color
[
    QGVAR(ToggleHeadsetColor),
    "COLOR",
    localize LSTRING(ToggleHeadsetColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Cycle Radios Color
[
    QGVAR(CycleRadiosColor),
    "COLOR",
    localize LSTRING(CycleRadiosColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Babel Color
[
    QGVAR(LanguageColor),
    "COLOR",
    localize LSTRING(LanguageColor_DisplayName),
    localize LSTRING(Category),
    [ACRE_NOTIFICATION_RED],
    false,
    {}
] call CBA_fnc_addSetting;

// Hint Text Font
private _fontNames = ["Etelka Monospace Pro", "Etelka Monospace Pro Bold", "LCD 14", "Purista Bold", "Purista Light", "Purista Medium", "Purista SemiBold", "Roboto Condensed", "Roboto Condensed Bold", "Roboto Condensed Light", "Tahoma B"];
private _fonts = ["EtelkaMonospacePro", "EtelkaMonospaceProBold", "LCD14", "PuristaBold", "PuristaLight", "PuristaMedium", "PuristaSemibold", "RobotoCondensed", "RobotoCondensedBold", "RobotoCondensedLight", "TahomaB"];
[
    QGVAR(HintTxtFont),
    "LIST",
    localize LSTRING(HintTxtFont_DisplayName),
    localize LSTRING(Category),
    [_fonts, _fontNames, 7],
    false,
    {}
] call CBA_fnc_addSetting;

// Enable PTT color customization
[
    QGVAR(ShowPTTColors),
    "CHECKBOX",
    localize LSTRING(ShowPTTColors_DisplayName),
    [localize LSTRING(Category), "PTT"],
    false,
    false,
    {}
] call CBA_fnc_addSetting;

// PTT1 Color
[
    QGVAR(PTT1Color),
    "COLOR",
    [localize LSTRING(PTT1Color_DisplayName), format [localize LSTRING(PTTColors_Description), localize LSTRING(ShowPTTColors_DisplayName)]],
    [localize LSTRING(Category), "PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT2 Color
[
    QGVAR(PTT2Color),
    "COLOR",
    [localize LSTRING(PTT2Color_DisplayName), format [localize LSTRING(PTTColors_Description), localize LSTRING(ShowPTTColors_DisplayName)]],
    [localize LSTRING(Category), "PTT"],
    [ACRE_NOTIFICATION_GREEN],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT3 Color
[
    QGVAR(PTT3Color),
    "COLOR",
    [localize LSTRING(PTT3Color_DisplayName), format [localize LSTRING(PTTColors_Description), localize LSTRING(ShowPTTColors_DisplayName)]],
    [localize LSTRING(Category), "PTT"],
    [ACRE_NOTIFICATION_BLUE],
    false,
    {}
] call CBA_fnc_addSetting;
