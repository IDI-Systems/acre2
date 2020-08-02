[
    QGVAR(txNotification),
    "CHECKBOX",
    localize LSTRING(txNotification_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    true,
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(rxNotification),
    "CHECKBOX",
    localize LSTRING(rxNotification_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    true,
    false,
    {}
] call CBA_fnc_addSetting;

// PTT Color
[
    QGVAR(PTTColor),
    "COLOR",
    localize LSTRING(PTTColor_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;
