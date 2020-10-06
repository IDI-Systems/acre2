[
    QGVAR(enabled),
    "CHECKBOX",
    [localize LSTRING(enabled),localize LSTRING(enabled_description)],
    localize LSTRING(category),
    true,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(stopADS),
    "CHECKBOX",
    [localize LSTRING(stopADS),localize LSTRING(stopADS_description)],
    localize LSTRING(category),
    false,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headsetRadios),
    "EDITBOX",
    [localize LSTRING(headsetRadios),localize LSTRING(headsetRadios_description)],
    localize LSTRING(category),
    "['ACRE_PRC148','ACRE_PRC152','ACRE_PRC117F','ACRE_SEM70']",
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(vestRadios),
    "EDITBOX",
    [localize LSTRING(vestRadios),localize LSTRING(vestRadios_description)],
    localize LSTRING(category),
    "['ACRE_PRC343','ACRE_PRC77','ACRE_SEM52SL']",
    false,
    {},
    true
] call CBA_fnc_addSetting;
