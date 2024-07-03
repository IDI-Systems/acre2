[
    QGVAR(rxNotification),
    "CHECKBOX",
    localize LSTRING(rxNotification_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    true,
    false,
    {}
] call CBA_fnc_addSetting;

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
    QGVAR(rxNotificationColor),
    "COLOR",
    localize LSTRING(rxNotificationColor_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(txNotificationCurrentChatColor),
    "COLOR",
    localize LSTRING(txNotificationCurrentChatColor_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(txNotificationGroup1Color),
    "COLOR",
    localize LSTRING(txNotificationGroup1Color_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(txNotificationGroup2Color),
    "COLOR",
    localize LSTRING(txNotificationGroup2Color_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;

[
    QGVAR(txNotificationGroup3Color),
    "COLOR",
    localize LSTRING(txNotificationGroup3Color_displayName),
    [ELSTRING(sys_core,CategoryUI), localize LSTRING(godMode)],
    [ACRE_NOTIFICATION_WHITE],
    false,
    {}
] call CBA_fnc_addSetting;
