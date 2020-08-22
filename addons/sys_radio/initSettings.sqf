
private _allRadios = [] call EFUNC(sys_core,getAllRadios);
private _radioClasses = [""] + _allRadios # 0;
private _radioNames = [localize "str_a3_cfgglasses_none0"] + _allRadios # 1;

[
    QGVAR(defaultItemRadioType),
    "LIST",
    [
        LLSTRING(DefaultItemRadioType_DisplayName),
        LLSTRING(DefaultItemRadioType_Description)
    ],
    "ACRE2",
    [
        _radioClasses,
        _radioNames,
        (_radioClasses find "ACRE_PRC343") max 0
    ],
    true
] call CBA_fnc_addSetting;
