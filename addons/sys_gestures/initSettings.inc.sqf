[
    QGVAR(enabled),
    "CHECKBOX",
    [LLSTRING(enabled), LLSTRING(enabled_description)],
    LLSTRING(category),
    true,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(stopADS),
    "CHECKBOX",
    [LLSTRING(stopADS), LLSTRING(stopADS_description)],
    LLSTRING(category),
    false,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(showConnectorRopes),
    "CHECKBOX",
    [LLSTRING(showConnectorRopes), LLSTRING(showConnectorRopes_description)],
    LLSTRING(category),
    true,
    true,
    {},
    true
] call CBA_fnc_addSetting;
