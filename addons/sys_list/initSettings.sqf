// Hint Background Color
[
    QGVAR(hintBgColor),
    "COLOR",
    localize LSTRING(hintBgColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_BG_BLACK],
    false,
    {}
] call CBA_fnc_addSetting;

// Transmit Color
[
    QGVAR(transmissionColor),
    "COLOR",
    localize LSTRING(transmissionColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// Channel Switch Color
[
    QGVAR(switchChannelColor),
    "COLOR",
    localize LSTRING(switchChannelColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Toggle Headset Color
[
    QGVAR(toggleHeadsetColor),
    "COLOR",
    localize LSTRING(toggleHeadsetColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Cycle Radios Color
[
    QGVAR(cycleRadiosColor),
    "COLOR",
    localize LSTRING(cycleRadiosColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_PURPLE],
    false,
    {}
] call CBA_fnc_addSetting;

// Babel Color
[
    QGVAR(languageColor),
    "COLOR",
    localize LSTRING(languageColor_displayName),
    localize LSTRING(ACREUI_displayName),
    [ACRE_NOTIFICATION_RED],
    false,
    {}
] call CBA_fnc_addSetting;

// Hint Text Font
private _fontNames = ["Etelka Monospace Pro", "Etelka Monospace Pro Bold", "LCD 14", "Purista Bold", "Purista Light", "Purista Medium", "Purista SemiBold", "Roboto Condensed", "Roboto Condensed Bold", "Roboto Condensed Light", "Tahoma B"];
private _fonts = ["EtelkaMonospacePro", "EtelkaMonospaceProBold", "LCD14", "PuristaBold", "PuristaLight", "PuristaMedium", "PuristaSemibold", "RobotoCondensed", "RobotoCondensedBold", "RobotoCondensedLight", "TahomaB"];
[
    QGVAR(hintTxtFont),
    "LIST",
    localize LSTRING(hintTxtFont_displayName),
    localize LSTRING(ACREUI_displayName),
    [_fonts, _fontNames, 10],
    false,
    {}
] call CBA_fnc_addSetting;

// Enable PTT color customization
[
    QGVAR(showPttColors),
    "CHECKBOX",
    localize LSTRING(showPttColors_displayName),
    [localize LSTRING(ACREUI_displayName),"PTT"],
    false,
    false,
    {}
] call CBA_fnc_addSetting;

// PTT1 Color
[
    QGVAR(ptt1Color),
    "COLOR",
    [localize LSTRING(ptt1Color_displayName),localize LSTRING(pttColorsDesc_displayName)],
    [localize LSTRING(ACREUI_displayName),"PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT2 Color
[
    QGVAR(ptt2Color),
    "COLOR",
    [localize LSTRING(ptt2Color_displayName),localize LSTRING(pttColorsDesc_displayName)],
    [localize LSTRING(ACREUI_displayName),"PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;

// PTT3 Color
[
    QGVAR(ptt3Color),
    "COLOR",
    [localize LSTRING(ptt3Color_displayName),localize LSTRING(pttColorsDesc_displayName)],
    [localize LSTRING(ACREUI_displayName),"PTT"],
    [ACRE_NOTIFICATION_YELLOW],
    false,
    {}
] call CBA_fnc_addSetting;
