private _zeusCategory = format ["ACRE2 %1", localize "str_a3_cfghints_curator_curator_displayname"];

// Default remote controlled voice source
[
    QGVAR(zeusDefaultVoiceSource),
    "LIST",
    LLSTRING(ZeusDefaultVoiceSource_DisplayName),
    _zeusCategory,
    [
        [false, true],
        ["str_a3_cfgvehicles_moduleremotecontrol_f", "STR_A3_Leaderboards_Header_Player"],
        0
    ]
] call CBA_fnc_addSetting;

// Ability to hear through the Zeus camera
[
    QGVAR(zeusListenViaCamera),
    "CHECKBOX",
    LLSTRING(ZeusListenViaCamera_DisplayName),
    _zeusCategory,
    true
] call CBA_fnc_addSetting;

// Ability to join the spectator chat
[
    QGVAR(zeusCanSpectate),
    "CHECKBOX",
    LLSTRING(ZeusCanSpectate_DisplayName),
    _zeusCategory,
    true
] call CBA_fnc_addSetting;
