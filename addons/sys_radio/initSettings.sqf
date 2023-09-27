[
    QGVAR(defaultRadio),
    "LIST",
    [LLSTRING(DefaultRadio_DisplayName), LLSTRING(DefaultRadio_Description)],
    "ACRE2",
    [
        [""] + (GVAR(defaultRadios) select 0),
        [localize "str_a3_cfgglasses_none0"] + (GVAR(defaultRadios) select 1),
        ((GVAR(defaultRadios) select 0) find "ACRE_PRC343") + 1
    ],
    true
] call CBA_fnc_addSetting;
