[
    QGVAR(enabled),
    "CHECKBOX",
    [LLSTRING(enabled),LLSTRING(enabled_description)],
    LLSTRING(category),
    true,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(stopADS),
    "CHECKBOX",
    [LLSTRING(stopADS),LLSTRING(stopADS_description)],
    LLSTRING(category),
    false,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headsetRadios),
    "EDITBOX",
    [LLSTRING(headsetRadios),LLSTRING(headsetRadios_description)],
    LLSTRING(category),
    "['ACRE_PRC148','ACRE_PRC152','ACRE_PRC117F','ACRE_SEM70']",
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(vestRadios),
    "EDITBOX",
    [LLSTRING(vestRadios),LLSTRING(vestRadios_description)],
    LLSTRING(category),
    "['ACRE_PRC343','ACRE_PRC77','ACRE_SEM52SL']",
    false,
    {},
    true
] call CBA_fnc_addSetting;
