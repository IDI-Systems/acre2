[
    QGVAR(enabled),
    "CHECKBOX",
    localize LSTRING(enabled),
    localize LSTRING(category),
    true,
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headsetRadios),
    "EDITBOX",
    localize LSTRING(headsetRadios),
    localize LSTRING(category),
    "['ACRE_PRC148','ACRE_PRC152','ACRE_PRC117F','ACRE_SEM70']",
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(vestRadios),
    "EDITBOX",
    localize LSTRING(vestRadios),
    localize LSTRING(category),
    "['ACRE_PRC343','ACRE_PRC77','ACRE_SEM52SL']",
    false,
    {},
    true
] call CBA_fnc_addSetting;
